Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6D91B59A
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 01:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738027218; cv=none; b=DGzPiea5kcj2ufHwzXAY9R5mf+Sg1Um7s3fX71NsaCtwZU7KLTvWQVPu1GtNHqbU4+FuDMc0W6OnR+FA3xPwjF1FlQfpq4daXjDGHgpBNUi2Eca3/Fo26idzo/BOcECM9k6c2xOL6SlaOwzz+ABeE9toKHSs57s5QnP6j86LqZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738027218; c=relaxed/simple;
	bh=7Vlg9k2+T1fz014C82sshDDVB+tIuLskNx0ZGfozmSI=;
	h=Date:To:From:Subject:Message-Id; b=hGkbdxXPEigv1kB+oSpK9UAly9KJnwa/6KrD38eW2U03fEzzasUNhEalytAFLLJKJI03LXxQNXkl+5Lzq2qWKtZyKKWcrGlF5ELDxYCunPp3LwsC5dMc0QBK+eFw7r7cBLcI1sNvLyPsGSjTxGgevsQcWg1BNJYKUVLWdpSw58Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNCfufyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNCfufyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC5BC4CED2;
	Tue, 28 Jan 2025 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738027216;
	bh=7Vlg9k2+T1fz014C82sshDDVB+tIuLskNx0ZGfozmSI=;
	h=Date:To:From:Subject:From;
	b=eNCfufyRq2tTNE/PrKcpFAkJC0gXkSxKYpMOew/fBo3phEEcxYtiV3hlxrD8ls9Ic
	 kQPLKnomQvYDxzvg+VnjuNRBM65sRVu9E3bj4zRJzMnihTKfdDIFeHhc42AjMbSiDm
	 gnN4S/fmvCASa88VrcppgIBchetQcKJCn7zkZaRU=
Date: Mon, 27 Jan 2025 17:20:15 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch added to mm-unstable branch
Message-Id: <20250128012015.EFC5BC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: remove low watermark cap for proactive compaction
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Michal Clapinski <mclapinski@google.com>
Subject: mm/compaction: remove low watermark cap for proactive compaction
Date: Mon, 27 Jan 2025 22:50:19 +0100

Patch series "mm/compaction: allow more aggressive proactive compaction",
v3.

Our goal is to keep memory usage of a VM low on the host.  For that
reason, we use free page reporting which by default reports free pages of
order 9 and larger to the host to be freed.  The feature works well only
if the memory in the guest is not fragmented below pages of order 9. 
Proactive compaction can be reused to achieve defragmentation after some
parameter tweaking.

When the fragmentation score (lower is better) gets larger than the high
watermark, proactive compaction kicks in.  Compaction stops when the score
goes below the low watermark (or no progress is made and backoff kicks
in).  Let's define the difference between high and low watermarks as
leeway.  Before these changes, the minimum possible value for low
watermark was 5 and the leeway was hardcoded to 10 (so minimum possible
value for high watermark was 15).


This patch (of 3):

Previously a min cap of 5 has been set in the commit introducing proactive
compaction.  This was to make sure users don't hurt themselves by setting
the proactiveness to 100 and making their system unresponsive.  But the
compaction mechanism has a backoff mechanism that will sleep for 30s if no
progress is made, so I don't see a significant risk here.  My system (20GB
of memory) has been perfectly fine with proactiveness set to 100 and
leeway set to 0.

Link: https://lkml.kernel.org/r/20250127215020.4023545-2-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-remove-low-watermark-cap-for-proactive-compaction
+++ a/mm/compaction.c
@@ -2256,7 +2256,7 @@ static unsigned int fragmentation_score_
 	 * activity in case a user sets the proactiveness tunable
 	 * close to 100 (maximum).
 	 */
-	wmark_low = max(100U - sysctl_compaction_proactiveness, 5U);
+	wmark_low = 100U - sysctl_compaction_proactiveness;
 	return low ? wmark_low : min(wmark_low + 10, 100U);
 }
 
_

Patches currently in -mm which might be from mclapinski@google.com are

mm-compaction-remove-low-watermark-cap-for-proactive-compaction.patch
mm-compaction-make-proactive-compaction-high-watermark-configurable-via-sysctl.patch

