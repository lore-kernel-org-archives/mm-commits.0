Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5728EB672
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771546429; cv=none; b=c6pJUq17RwR/aT+iFCSXylnnR+Ul9nH830PuIrn99l/7C2B3zHGsBebS+Dg0oA2Hb+Vp3LxpAGZqkDuiaNttDbOZz1HzDiRpgxxUsF62hotfdOlEg/7B47db9XUJfa4stoGq9f5tpSSBklrM6ghR+cnUY+usjj9nPW8hCicA9v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771546429; c=relaxed/simple;
	bh=P4SP5sqL88mGyQLw7jx9Pp3GCxMT977a+AC8ubGBiPA=;
	h=Date:To:From:Subject:Message-Id; b=TBmn/mmaBm6kJGobRE7giy1LeN8IPFufd8lznVacTDcy1mUzRhJ//V8fBhJ6RsPOH13789VYeVTrYtbm4ZFHWb+6Nf5ZEU+Kt214IJTGxaU/TU80jFWjtPAphGBERAnQwlbvrpy8fQ8RZI0jTVfT9BwSGioGHHdRcpAbYY+uGM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KCNPHT1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KCNPHT1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4380EC4CEF7;
	Fri, 20 Feb 2026 00:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771546428;
	bh=P4SP5sqL88mGyQLw7jx9Pp3GCxMT977a+AC8ubGBiPA=;
	h=Date:To:From:Subject:From;
	b=KCNPHT1RlHzFO9xD2lHjT8x66O2TsdDwMrE0+aS0HR9OqOKFdgNiip/QdiOUJ3Enf
	 3YuDaN6P16Z4XFp3tW9M1V8lOJVf8qRB17Z+IjGvq69ie+8PEfVP9YNgsLnpCCodhz
	 IioIStnmFsJz3GDxK4gZSldds3mMuL9AE9+E5ONs=
Date: Thu, 19 Feb 2026 16:13:47 -0800
To: mm-commits@vger.kernel.org,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-check-xz-dictionary-size-isnt-zero.patch added to mm-nonmm-unstable branch
Message-Id: <20260220001348.4380EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: check xz dictionary size isn't zero
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-check-xz-dictionary-size-isnt-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-xz-dictionary-size-isnt-zero.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check xz dictionary size isn't zero
Date: Tue, 17 Feb 2026 23:15:37 +0000

Syzkaller reports a "UBSAN: shift-out-of-bounds in squashfs_xz_comp_opts"

This is caused by a zero dict_size value read from disk, which produces a
negative shift.

The fix is to check that the dict_size is not zero.

Link: https://lkml.kernel.org/r/20260217231537.206436-1-phillip@squashfs.org.uk
Fixes: ff750311d30a ("Squashfs: add compression options support to xz decompressor")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+99fc070a2affcd27784b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6994c60f.a70a0220.2c38d7.0108.GAE@google.com/
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/xz_wrapper.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/squashfs/xz_wrapper.c~squashfs-check-xz-dictionary-size-isnt-zero
+++ a/fs/squashfs/xz_wrapper.c
@@ -58,9 +58,9 @@ static void *squashfs_xz_comp_opts(struc
 		opts->dict_size = le32_to_cpu(comp_opts->dictionary_size);
 
 		/* the dictionary size should be 2^n or 2^n+2^(n+1) */
-		n = ffs(opts->dict_size) - 1;
-		if (opts->dict_size != (1 << n) && opts->dict_size != (1 << n) +
-						(1 << (n + 1))) {
+		n = ffs(opts->dict_size);
+		if (n-- == 0 || (opts->dict_size != (1 << n) &&
+				opts->dict_size != (1 << n) + (1 << (n + 1)))) {
 			err = -EIO;
 			goto out;
 		}
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-check-metadata-block-offset-is-within-range.patch
squashfs-check-xz-dictionary-size-isnt-zero.patch

