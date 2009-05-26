From: akpm@linux-foundation.org
Subject: [merged] asm-generic-fix-local_add_unless-macro.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:09 -0700
Message-ID: <200905261935.n4QJZ9Hd006106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755830AbZEZTfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     asm-generic: fix local_add_unless macro
has been removed from the -mm tree.  Its filename was
     asm-generic-fix-local_add_unless-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic: fix local_add_unless macro
From: Roel Kluin <roel.kluin@gmail.com>

`local_add_unless(x, y, z)' will be expanded to `(&(x)->y, (y), (x))', but
`&(x)->y' should be `&(x)->a'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/local.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/local.h~asm-generic-fix-local_add_unless-macro include/asm-generic/local.h
--- a/include/asm-generic/local.h~asm-generic-fix-local_add_unless-macro
+++ a/include/asm-generic/local.h
@@ -42,7 +42,7 @@ typedef struct
 
 #define local_cmpxchg(l, o, n) atomic_long_cmpxchg((&(l)->a), (o), (n))
 #define local_xchg(l, n) atomic_long_xchg((&(l)->a), (n))
-#define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
+#define local_add_unless(l, _a, u) atomic_long_add_unless((&(l)->a), (_a), (u))
 #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
 
 /* Non-atomic variants, ie. preemption disabled and won't be touched
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

