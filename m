From: akpm@linux-foundation.org
Subject: + bitmap-replace-bitmap_fromto_u32array-fix.patch added to -mm
 tree
Date: Thu, 01 Feb 2018 14:28:00 -0800
Message-ID: <5a739470.9q+fc8wR9R01BQ0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbeBAW2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 17:28:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: perf: arm_dsu_pmu: convert to bitmap_from_arr32
has been added to the -mm tree.  Its filename is
     bitmap-replace-bitmap_fromto_u32array-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-replace-bitmap_fromto_u32array-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-replace-bitmap_fromto_u32array-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: perf: arm_dsu_pmu: convert to bitmap_from_arr32

The bitmap_from_u32array() interface got replaced in a global change, but
the arm_dsu_pmu driver adds another instance, resulting in a build
failure:

drivers/perf/arm_dsu_pmu.c: In function 'dsu_pmu_probe_pmu':
drivers/perf/arm_dsu_pmu.c:661:2: error: implicit declaration of function 'bitmap_from_u32array'; did you mean 'bitmap_from_arr32'? [-Werror=implicit-function-declaration]

This changes the new instance accordingly.

Link: http://lkml.kernel.org/r/20180201172508.5739-2-ynorov@caviumnetworks.com
Fixes: mmotm ("bitmap: replace bitmap_{from,to}_u32array")
Fixes: 7520fa99246d ("perf: ARM DynamIQ Shared Unit PMU support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/perf/arm_dsu_pmu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/perf/arm_dsu_pmu.c~bitmap-replace-bitmap_fromto_u32array-fix drivers/perf/arm_dsu_pmu.c
--- a/drivers/perf/arm_dsu_pmu.c~bitmap-replace-bitmap_fromto_u32array-fix
+++ a/drivers/perf/arm_dsu_pmu.c
@@ -658,10 +658,8 @@ static void dsu_pmu_probe_pmu(struct dsu
 		return;
 	cpmceid[0] = __dsu_pmu_read_pmceid(0);
 	cpmceid[1] = __dsu_pmu_read_pmceid(1);
-	bitmap_from_u32array(dsu_pmu->cpmceid_bitmap,
-				DSU_PMU_MAX_COMMON_EVENTS,
-				cpmceid,
-				ARRAY_SIZE(cpmceid));
+	bitmap_from_arr32(dsu_pmu->cpmceid_bitmap, cpmceid,
+			  DSU_PMU_MAX_COMMON_EVENTS);
 }
 
 static void dsu_pmu_set_active_cpu(int cpu, struct dsu_pmu *dsu_pmu)
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-added-functions-for-unpoisoning-stack-variables-fix-fix.patch
bugh-work-around-gcc-pr82365-in-bug.patch
bitmap-replace-bitmap_fromto_u32array-fix.patch
nilfs2-use-time64_t-internally.patch
pps-parport-use-timespec64-instead-of-timespec.patch
kasan-rework-kconfig-settings.patch

