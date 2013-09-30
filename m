From: akpm@linux-foundation.org
Subject: [merged] hpet-remove-useless-check-if-fixmem32-is-null.patch
 removed from -mm tree
Date: Mon, 30 Sep 2013 15:22:12 -0700
Message-ID: <5249f994.Ubt7f/mLMUxdifCW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab3I3WWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 18:22:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, prarit@redhat.com, msw@amazon.com, clemens@ladisch.de, tomas.winkler@intel.com

Subject: [merged] hpet-remove-useless-check-if-fixmem32-is-null.patch removed from -mm tree
To: tomas.winkler@intel.com,clemens@ladisch.de,msw@amazon.com,prarit@redhat.com,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 15:22:12 -0700


The patch titled
     Subject: drivers/char/hpet.c: remove useless check if fixmem32 is NULL
has been removed from the -mm tree.  Its filename was
     hpet-remove-useless-check-if-fixmem32-is-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomas Winkler <tomas.winkler@intel.com>
Subject: drivers/char/hpet.c: remove useless check if fixmem32 is NULL

fixmem32 is assigned to address of res->data member so the address is
always valid

Actually since we are not checking for res != NULL static analyzing is
complaining about referencing the pointer and consequent check for null. 
The code snippet looks confusing also for human eyes.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Matt Wilson <msw@amazon.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/hpet.c~hpet-remove-useless-check-if-fixmem32-is-null drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-remove-useless-check-if-fixmem32-is-null
+++ a/drivers/char/hpet.c
@@ -971,8 +971,6 @@ static acpi_status hpet_resources(struct
 		struct acpi_resource_fixed_memory32 *fixmem32;
 
 		fixmem32 = &res->data.fixed_memory32;
-		if (!fixmem32)
-			return AE_NO_MEMORY;
 
 		hdp->hd_phys_address = fixmem32->address;
 		hdp->hd_address = ioremap(fixmem32->address,
_

Patches currently in -mm which might be from tomas.winkler@intel.com are

hpet-allow-user-controlled-mmap-for-user-processes.patch
linux-next.patch

