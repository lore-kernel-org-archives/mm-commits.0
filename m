Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793402424;
	b=d5D/bzY7eM49gMj9v1R/zomovW01i/QmTiNNX818pNz7/1eAEAQKDyvux830Bv36eMzm
	 RKNxRJmsgQtfFgGMIDjfA93+QLQcrrb3L1CiY2j6e8RCDlE0k0qOjlYwSXv7A2/mLZR71
	 syuJ9bxONGmIHiGAoDnqLDRbI/WLicktMXxKsVqv/s2AzmZ3Z0LhhoHOA1Qu6VU/95dR+
	 GSTl1tkiDVsA8cDJdgbFku1H14vwgGLPjsYfIZv3A75ku+xe0Lj4OZnXWYNtslROuXyhb
	 Oml24kbnSO956QsaNNtNIAfIUoxEWAFtATtNauFPmT6bjUXHNu5O3U+DMrSYef6nIew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793402424;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CVoIUj+wqSYWUMFplYJOhjdC2FhDHMkeY1lOvE3uG14=;
	b=rG9Ri9fLE1QQwkh5rIVvs6SuJ0WtXuBK9F7PWP4pWq8eCOz/pXSQviW38oVKPADfJ89H
	 uaZXqoA6pTj9L0dKfLZzgbSVM0vTvouBC0mzpsN0tgGEw4POg20lLfUWOmt0+exa34wPn
	 qM3jefHUHtEG2MfhZOt0s4ZgQKtxKCpD8WtH3Y8pxqbGBq2bXC9gykfEeYFvUmtrIPWA3
	 TVh1+rVlogUKyXrW6UK4s4826KkUrvusno4nfnqVXjEgBjAbJErJ1eTSBZtvs1x+7eCmf
	 lIcFYCMThe6Byl7fexqGO4u2avhNLr/3ZiT92P4GNgY+P8Yfg/JNLH0Uy4mO/ZXRmOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UQtg6+bR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F6606A31F
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UQtg6+bR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8431F000C1;
	Fri, 30 Oct 2026 23:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793402423;
	bh=CVoIUj+wqSYWUMFplYJOhjdC2FhDHMkeY1lOvE3uG14=;
	h=Date:To:From:Subject;
	b=UQtg6+bRLUtxYg/8osnH95clRNaCy9/sG2xhgdBGYroOQM2I0IHi13mpWNcs/yqCR
	 TifIajJW/YBaoILzDCK93VARMbq642751yHLK1RlQEqLwr429ecTk1u5S4LOtFk8v2
	 J8YyJZ65KBsEKaH5knUQF2xL3p0NM8xDbv+e9NFA=
Date: Fri, 30 Oct 2026 16:20:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch added to mm-new branch
Message-Id: <20261030232023.BD8431F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix
Date: Fri Oct 30 04:18:27 PM PDT 2026

read_pmd_pagesize() was renamed to pmd_psize()

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/madv_cold_pageout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/madv_cold_pageout.c~selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix
+++ a/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -711,7 +711,7 @@ int main(int argc, char **argv)
 	int pagemap_fd;
 
 	page_size = getpagesize();
-	pmd_size = read_pmd_pagesize();
+	pmd_size = pmd_psize();
 	/* The harness forks each test, which inherits this. */
 	pin_to_current_cpu();
 	/* Only root can reserve the page that hugetlb_vma_is_rejected maps. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

openrisc-export-mulsi3.patch
mm-mempolicy-use-one-node-set-for-interleave-weights.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
maintainers-add-ipc-maintainers.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

