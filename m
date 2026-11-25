Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795640921;
	b=uAR2qSiylk5r80XV5qJM3KKbCy3vQ15kEQCN6ChXWnuHInpYlaWOQGIWgD27vehtEw3R
	 2FNKk5KjaTu9Zj2FfNZVo2SiccoKzreLd5QgK71L++TGLmIgUNKGOh+F3QGtwIN1ebbN9
	 6tfzfCkZbriRS/Psvhk3ne6fYECE5iovHUBbGKTZjPUolJzCXvOatvF22hYPL/TOW29au
	 NYTRM64i1dQTz5/51f1BSWG67tAtYIk5qcIdVbe1pLpp6H8IAA3VkguVSidDk2orP2M8D
	 dMs4fPm+LiZvtXYyH0JOjJbPNB/yROXqYdZL2miOV2VxtAX3KInLDY2XT2V+/LJetNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795640921;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=9pTM1f0slv7juZylMVenTImMnweK3kkZ0NenR+uz0+c=;
	b=EW+mRw7dOEcaOAsRp2+DyAtXtRRW3YqQFvtTv0yPWH1EnZQjq68nhlOGlu8MVpfnJ4rU
	 yP4Zj/iE1v45EsrPgpbD7Cs4RF0SEnAF+LeL7jG8SDVSahfFVkcPd5gVbQnaTMXR8WK8H
	 6bvrdesdCTbMdLfHsOg6jJnwhEIIRoAlEfOMaaDKUQLkiP1R/lPSx2qAF9/PF7FD8T3gp
	 6+lo9+v6qqfR2oEeuaDXQgw0MvcVyuIL8aFzpCI8MFcJwgYmy0uoLzgZX4oynmtqCEYPG
	 DQXkTEleqraBhbmuvjYXsmP5/qokDym27ZjE/sq7tZRzCOczVxOqX3OAyV1fd9yKPCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x6fjlJjH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F58606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 21:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x6fjlJjH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8076A1F000C0;
	Wed, 25 Nov 2026 21:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795640920;
	bh=9pTM1f0slv7juZylMVenTImMnweK3kkZ0NenR+uz0+c=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=x6fjlJjHygbNL7L0w9Ns+d9EGzFpiHxI7cUpIIlbFY1dFrrDMbLb6Vcr5YNcNfu4/
	 pdykStBcqEyul6DqSOmF1qsQ+imvPsoCvfgYA/cOo8QZm+PEJpSIRV49562YwVAshm
	 EM3+5kqNk7S2u3g4Bzk06b7uKB852n7SltKjS2eI=
Date: Wed, 25 Nov 2026 13:08:39 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,chansen3@cisco.com,wangxuewen@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125091408.1584017-1-wangxuewen_ky@163.com>
References: <20261125091408.1584017-1-wangxuewen_ky@163.com>
Subject: + tools-mm-page-types-flush-pending-idle-bitmap-bits-after-walking.patch added to mm-new branch
Message-Id: <20261125210840.8076A1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/mm: page-types: flush pending idle bitmap bits after walking
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page-types-flush-pending-idle-bitmap-bits-after-walking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page-types-flush-pending-idle-bitmap-bits-after-walking.patch

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
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: tools/mm: page-types: flush pending idle bitmap bits after walking
Date: Wed, 25 Nov 2026 17:14:08 +0800

mark_page_idle() buffers bits for one 64-page bitmap word and writes that
word when a page in another word is encountered.

walk_addr_ranges() tries to flush the final word by marking PFN 0.  If the
last buffered PFN is below 64, this only adds a bit to the same word and
nothing is written.  Otherwise it writes the pending word but leaves an
unwanted PFN 0 bit buffered.  walk_page_cache() does not flush at all, so
its final pending bits are not written.

Extract the write operation into flush_page_idle() and use it both when
changing words and after either walker returns to main().  Clear the
buffer after a successful write and skip writes when it is empty.  Place
the final flush before the no-summary early return and return EXIT_FAILURE
if it fails.

Use 1ULL for the bit mask so shifts by 32 through 63 are also valid on
32-bit hosts.

Link: https://patch.msgid.link/20261125091408.1584017-1-wangxuewen_ky@163.com
Fixes: 59ae96ffc3a6 ("tools/vm/page-types.c: add support for idle page tracking")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Christian Hansen <chansen3@cisco.com>
Cc: SJ Park <sj@kernel.org>

 tools/mm/page-types.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

--- a/tools/mm/page-types.c~tools-mm-page-types-flush-pending-idle-bitmap-bits-after-walking
+++ a/tools/mm/page-types.c
@@ -575,27 +575,39 @@ static int unpoison_page(unsigned long o
 	return 0;
 }
 
-static int mark_page_idle(unsigned long offset)
+static unsigned long page_idle_offset;
+static uint64_t page_idle_buf;
+
+static int flush_page_idle(void)
 {
-	static unsigned long off;
-	static uint64_t buf;
 	int len;
 
-	if ((offset / 64 == off / 64) || buf == 0) {
-		buf |= 1UL << (offset % 64);
-		off = offset;
+	if (!page_idle_buf)
 		return 0;
-	}
 
-	len = pwrite(page_idle_fd, &buf, 8, 8 * (off / 64));
+	len = pwrite(page_idle_fd, &page_idle_buf, 8,
+		     8 * (page_idle_offset / 64));
 	if (len < 0) {
 		perror("mark page idle");
 		return len;
 	}
 
-	buf = 1UL << (offset % 64);
-	off = offset;
+	page_idle_buf = 0;
+	return 0;
+}
 
+static int mark_page_idle(unsigned long offset)
+{
+	int ret;
+
+	if (offset / 64 != page_idle_offset / 64) {
+		ret = flush_page_idle();
+		if (ret < 0)
+			return ret;
+	}
+
+	page_idle_buf |= 1ULL << (offset % 64);
+	page_idle_offset = offset;
 	return 0;
 }
 
@@ -798,9 +810,6 @@ static void walk_addr_ranges(void)
 		else
 			walk_task(opt_offset[i], opt_size[i]);
 
-	if (opt_mark_idle)
-		mark_page_idle(0);
-
 	close(kpageflags_fd);
 }
 
@@ -1364,6 +1373,9 @@ int main(int argc, char *argv[])
 	else
 		walk_addr_ranges();
 
+	if (opt_mark_idle && flush_page_idle() < 0)
+		return EXIT_FAILURE;
+
 	if (opt_list == 1)
 		flush_page_range();
 
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-shrinker-stop-counting-when-the-seq-buffer-overflows.patch
tools-mm-page-types-flush-pending-idle-bitmap-bits-after-walking.patch

