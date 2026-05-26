Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACB83C5856
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 22:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779834302; cv=none; b=KB/iM4FqKJTEdOTf63va4p5NTXsPDW2StJZAzjdkFgAzP4ckAqBZpH8qtb4hVZNQC8VmY49r8YUn3CWBpANKMFr6swRim2evtxTZnwEibwIWmqwT/pbxqbjB3v1EBbRWVHLf7IjIM8+Q7uJ7xH1Pn23z/KFZqEv9DdB0LH/uFwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779834302; c=relaxed/simple;
	bh=XbKW7W43z3Gz4XU7iRKsmpOk3BI8DZXAyXlr3F4NUx4=;
	h=Date:To:From:Subject:Message-Id; b=onR2+QRHgWH8X9eHugsrgo90ca1i4dKnhUX9Ogjy5AYRsA75W+0Vm66BesRNzRJmt+8Bp4nxhsh4sq6M8ulBegt+km413BpL+0MYowe+k+ICcmGiMwoO7ayEux5soL54eicWoFOCP64PndQ9I5nioZC5oZBtLYur/BPSXwA9tSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FjQxnQup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FjQxnQup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551D71F000E9;
	Tue, 26 May 2026 22:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779834300;
	bh=GHf9MPeHAn+A6XSVbJeJGTFIvsksS7iJSEBLQ3Fcz6s=;
	h=Date:To:From:Subject;
	b=FjQxnQup4doXMM3wmRBGxbPDIysAbP3pZW22Na/xYbBw30iae9gHG/jdgElvxGyKX
	 qnE9DwNTg+W+Wvfirt22+jeRc5b6cPjsh5CdyxYlwNDWde4M6UN6ssn/GvdXniqZeY
	 z6rApqWONTLldj7loZL7PVrzjL9zo87wyLQD0g30=
Date: Tue, 26 May 2026 15:24:59 -0700
To: mm-commits@vger.kernel.org,mchehab@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch added to mm-nonmm-unstable branch
Message-Id: <20260526222500.551D71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/media/v4l2-core/v4l2-vp9.c: reduce inlining
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/media/v4l2-core/v4l2-vp9.c: reduce inlining
Date: Tue May 26 03:14:09 PM PDT 2026

csky allmodconfig, gcc-15.2.0:

drivers/media/v4l2-core/v4l2-vp9.c: In function 'v4l2_vp9_adapt_noncoef_probs':
drivers/media/v4l2-core/v4l2-vp9.c:1834:1: error: the frame size of 1436 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

The amount of inlining in there is simply nuts.  This patch semi-randomly
uninlines various things and fixes the above.

Ad the .text size reduction is tremendous:

ts:/usr/src/25> size drivers/media/v4l2-core/v4l2-vp9.o
   text	   data	    bss	    dec	    hex	filename
  22450	     36	      0	  22486	   57d6	drivers/media/v4l2-core/v4l2-vp9.o-before
  16144	     36	      0	  16180	   3f34	drivers/media/v4l2-core/v4l2-vp9.o-after

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/v4l2-vp9.c |   30 +++++++++++++--------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-vp9.c~drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining
+++ a/drivers/media/v4l2-core/v4l2-vp9.c
@@ -1582,25 +1582,25 @@ static inline u8 noncoef_merge_prob(u8 p
  *	merge_prob(p[9], c[9], [10])
  */
 
-static inline void merge_probs_variant_a(u8 *p, const u32 *c, u16 count_sat, u32 update_factor)
+static noinline_for_stack void merge_probs_variant_a(u8 *p, const u32 *c, u16 count_sat, u32 update_factor)
 {
 	p[1] = merge_prob(p[1], c[0], c[1] + c[2], count_sat, update_factor);
 	p[2] = merge_prob(p[2], c[1], c[2], count_sat, update_factor);
 }
 
-static inline void merge_probs_variant_b(u8 *p, const u32 *c, u16 count_sat, u32 update_factor)
+static noinline_for_stack void merge_probs_variant_b(u8 *p, const u32 *c, u16 count_sat, u32 update_factor)
 {
 	p[0] = merge_prob(p[0], c[0], c[1], count_sat, update_factor);
 }
 
-static inline void merge_probs_variant_c(u8 *p, const u32 *c)
+static noinline_for_stack void merge_probs_variant_c(u8 *p, const u32 *c)
 {
 	p[0] = noncoef_merge_prob(p[0], c[2], c[1] + c[0] + c[3]);
 	p[1] = noncoef_merge_prob(p[1], c[0], c[1] + c[3]);
 	p[2] = noncoef_merge_prob(p[2], c[1], c[3]);
 }
 
-static void merge_probs_variant_d(u8 *p, const u32 *c)
+static noinline_for_stack void merge_probs_variant_d(u8 *p, const u32 *c)
 {
 	u32 sum = 0, s2;
 
@@ -1624,20 +1624,20 @@ static void merge_probs_variant_d(u8 *p,
 	p[8] = noncoef_merge_prob(p[8], c[6], c[7]);
 }
 
-static inline void merge_probs_variant_e(u8 *p, const u32 *c)
+static noinline_for_stack void merge_probs_variant_e(u8 *p, const u32 *c)
 {
 	p[0] = noncoef_merge_prob(p[0], c[0], c[1] + c[2] + c[3]);
 	p[1] = noncoef_merge_prob(p[1], c[1], c[2] + c[3]);
 	p[2] = noncoef_merge_prob(p[2], c[2], c[3]);
 }
 
-static inline void merge_probs_variant_f(u8 *p, const u32 *c)
+static noinline_for_stack void merge_probs_variant_f(u8 *p, const u32 *c)
 {
 	p[0] = noncoef_merge_prob(p[0], c[0], c[1] + c[2]);
 	p[1] = noncoef_merge_prob(p[1], c[1], c[2]);
 }
 
-static void merge_probs_variant_g(u8 *p, const u32 *c)
+static noinline_for_stack void merge_probs_variant_g(u8 *p, const u32 *c)
 {
 	u32 sum;
 
@@ -1659,12 +1659,12 @@ static void merge_probs_variant_g(u8 *p,
 }
 
 /* 8.4.3 Coefficient probability adaptation process */
-static inline void adapt_probs_variant_a_coef(u8 *p, const u32 *c, u32 update_factor)
+static noinline_for_stack void adapt_probs_variant_a_coef(u8 *p, const u32 *c, u32 update_factor)
 {
 	merge_probs_variant_a(p, c, 24, update_factor);
 }
 
-static inline void adapt_probs_variant_b_coef(u8 *p, const u32 *c, u32 update_factor)
+static noinline_for_stack void adapt_probs_variant_b_coef(u8 *p, const u32 *c, u32 update_factor)
 {
 	merge_probs_variant_b(p, c, 24, update_factor);
 }
@@ -1724,33 +1724,33 @@ static inline void adapt_probs_variant_b
 	merge_probs_variant_b(p, c, 20, 128);
 }
 
-static inline void adapt_probs_variant_c(u8 *p, const u32 *c)
+static noinline_for_stack void adapt_probs_variant_c(u8 *p, const u32 *c)
 {
 	merge_probs_variant_c(p, c);
 }
 
-static inline void adapt_probs_variant_d(u8 *p, const u32 *c)
+static noinline_for_stack void adapt_probs_variant_d(u8 *p, const u32 *c)
 {
 	merge_probs_variant_d(p, c);
 }
 
-static inline void adapt_probs_variant_e(u8 *p, const u32 *c)
+static noinline_for_stack void adapt_probs_variant_e(u8 *p, const u32 *c)
 {
 	merge_probs_variant_e(p, c);
 }
 
-static inline void adapt_probs_variant_f(u8 *p, const u32 *c)
+static noinline_for_stack void adapt_probs_variant_f(u8 *p, const u32 *c)
 {
 	merge_probs_variant_f(p, c);
 }
 
-static inline void adapt_probs_variant_g(u8 *p, const u32 *c)
+static noinline_for_stack void adapt_probs_variant_g(u8 *p, const u32 *c)
 {
 	merge_probs_variant_g(p, c);
 }
 
 /* 8.4.4 Non coefficient probability adaptation process, adapt_prob() */
-static inline u8 adapt_prob(u8 prob, const u32 counts[2])
+static noinline_for_stack u8 adapt_prob(u8 prob, const u32 counts[2])
 {
 	return noncoef_merge_prob(prob, counts[0], counts[1]);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix-2.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

