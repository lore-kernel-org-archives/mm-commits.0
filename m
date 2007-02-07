From: akpm@linux-foundation.org
Subject: + rcutorture-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:06:09 -0800
Message-ID: <200702070006.l1706AwV001178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56120 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030231AbXBGAGl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:06:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, paulmck@us.ibm.com


The patch titled
     rcutorture: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     rcutorture-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rcutorture: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcutorture.c~rcutorture-use-array_size-macro-when-appropriate kernel/rcutorture.c
--- a/kernel/rcutorture.c~rcutorture-use-array_size-macro-when-appropriate
+++ a/kernel/rcutorture.c
@@ -966,7 +966,7 @@ rcu_torture_init(void)
 	/* Set up the freelist. */
 
 	INIT_LIST_HEAD(&rcu_torture_freelist);
-	for (i = 0; i < sizeof(rcu_tortures) / sizeof(rcu_tortures[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rcu_tortures); i++) {
 		rcu_tortures[i].rtort_mbtest = 0;
 		list_add_tail(&rcu_tortures[i].rtort_free,
 			      &rcu_torture_freelist);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
dvb-use-array_size-macro-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
atm-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
intel-agp-use-array_size-macro-when-appropriate.patch
reiserfs-use-array_size-macro-when-appropriate.patch
toshiba-acpi-use-array_size-macro-when-appropriate.patch
drm-use-array_size-macro-when-appropriate.patch
