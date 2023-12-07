Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5D7C10DCE
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbjLGWEx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjLGWEf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:04:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B241E122
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:04:41 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C315C433CD;
        Thu,  7 Dec 2023 22:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701986681;
        bh=93WBrmDot8YGGzYnSzLvu1wH2FITYNtNSIc5bwuOmtg=;
        h=Date:To:From:Subject:From;
        b=DI34LPmCFblYKCUSRgoA4wzx3F1sQVpARCtQC01MEqa+lDxLAiFBNUeb1uvs6YONq
         nPOGMDrYgjvGEpoG9KHN1osgdmZB6scoMeeLesaBnFflkQK4XwdbRbq0J5RQAnM0cE
         HCd2A0aFumh+95/s4fmkRqQOoErFU34EGnjJuZ3c=
Date:   Thu, 07 Dec 2023 14:04:40 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, v-songbaohua@oppo.com, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch added to mm-unstable branch
Message-Id: <20231207220441.4C315C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: support multi-size THP interface in thp_settings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: support multi-size THP interface in thp_settings
Date: Thu, 7 Dec 2023 16:12:08 +0000

Save and restore the new per-size hugepage enabled setting, if available
on the running kernel.

Since the number of per-size directories is not fixed, solve this as
simply as possible by catering for a maximum number in the thp_settings
struct (20).  Each array index is the order.  The value of THP_NEVER is
changed to 0 so that all of these new settings default to THP_NEVER and
the user only needs to fill in the ones they want to enable.

Link: https://lkml.kernel.org/r/20231207161211.2374093-8-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c   |    3 +
 tools/testing/selftests/mm/thp_settings.c |   55 +++++++++++++++++++-
 tools/testing/selftests/mm/thp_settings.h |   11 +++-
 3 files changed, 67 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-support-multi-size-thp-interface-in-thp_settings
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1141,6 +1141,7 @@ static void parse_test_type(int argc, co
 
 int main(int argc, const char **argv)
 {
+	int hpage_pmd_order;
 	struct thp_settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
@@ -1175,11 +1176,13 @@ int main(int argc, const char **argv)
 		exit(EXIT_FAILURE);
 	}
 	hpage_pmd_nr = hpage_pmd_size / page_size;
+	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
+	default_settings.hugepages[hpage_pmd_order].enabled = THP_INHERIT;
 
 	save_settings();
 	thp_push_settings(&default_settings);
--- a/tools/testing/selftests/mm/thp_settings.c~selftests-mm-support-multi-size-thp-interface-in-thp_settings
+++ a/tools/testing/selftests/mm/thp_settings.c
@@ -16,9 +16,10 @@ static struct thp_settings saved_setting
 static char dev_queue_read_ahead_path[PATH_MAX];
 
 static const char * const thp_enabled_strings[] = {
+	"never",
 	"always",
+	"inherit",
 	"madvise",
-	"never",
 	NULL
 };
 
@@ -198,6 +199,10 @@ void thp_write_num(const char *name, uns
 
 void thp_read_settings(struct thp_settings *settings)
 {
+	unsigned long orders = thp_supported_orders();
+	char path[PATH_MAX];
+	int i;
+
 	*settings = (struct thp_settings) {
 		.thp_enabled = thp_read_string("enabled", thp_enabled_strings),
 		.thp_defrag = thp_read_string("defrag", thp_defrag_strings),
@@ -218,11 +223,26 @@ void thp_read_settings(struct thp_settin
 	};
 	if (dev_queue_read_ahead_path[0])
 		settings->read_ahead_kb = read_num(dev_queue_read_ahead_path);
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & orders)) {
+			settings->hugepages[i].enabled = THP_NEVER;
+			continue;
+		}
+		snprintf(path, PATH_MAX, "hugepages-%ukB/enabled",
+			(getpagesize() >> 10) << i);
+		settings->hugepages[i].enabled =
+			thp_read_string(path, thp_enabled_strings);
+	}
 }
 
 void thp_write_settings(struct thp_settings *settings)
 {
 	struct khugepaged_settings *khugepaged = &settings->khugepaged;
+	unsigned long orders = thp_supported_orders();
+	char path[PATH_MAX];
+	int enabled;
+	int i;
 
 	thp_write_string("enabled", thp_enabled_strings[settings->thp_enabled]);
 	thp_write_string("defrag", thp_defrag_strings[settings->thp_defrag]);
@@ -242,6 +262,15 @@ void thp_write_settings(struct thp_setti
 
 	if (dev_queue_read_ahead_path[0])
 		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & orders))
+			continue;
+		snprintf(path, PATH_MAX, "hugepages-%ukB/enabled",
+			(getpagesize() >> 10) << i);
+		enabled = settings->hugepages[i].enabled;
+		thp_write_string(path, thp_enabled_strings[enabled]);
+	}
 }
 
 struct thp_settings *thp_current_settings(void)
@@ -294,3 +323,27 @@ void thp_set_read_ahead_path(char *path)
 		sizeof(dev_queue_read_ahead_path));
 	dev_queue_read_ahead_path[sizeof(dev_queue_read_ahead_path) - 1] = '\0';
 }
+
+unsigned long thp_supported_orders(void)
+{
+	unsigned long orders = 0;
+	char path[PATH_MAX];
+	char buf[256];
+	int ret;
+	int i;
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/enabled",
+			(getpagesize() >> 10) << i);
+		if (ret >= PATH_MAX) {
+			printf("%s: Pathname is too long\n", __func__);
+			exit(EXIT_FAILURE);
+		}
+
+		ret = read_file(path, buf, sizeof(buf));
+		if (ret)
+			orders |= 1UL << i;
+	}
+
+	return orders;
+}
--- a/tools/testing/selftests/mm/thp_settings.h~selftests-mm-support-multi-size-thp-interface-in-thp_settings
+++ a/tools/testing/selftests/mm/thp_settings.h
@@ -7,9 +7,10 @@
 #include <stdint.h>
 
 enum thp_enabled {
+	THP_NEVER,
 	THP_ALWAYS,
+	THP_INHERIT,
 	THP_MADVISE,
-	THP_NEVER,
 };
 
 enum thp_defrag {
@@ -29,6 +30,12 @@ enum shmem_enabled {
 	SHMEM_FORCE,
 };
 
+#define NR_ORDERS 20
+
+struct hugepages_settings {
+	enum thp_enabled enabled;
+};
+
 struct khugepaged_settings {
 	bool defrag;
 	unsigned int alloc_sleep_millisecs;
@@ -46,6 +53,7 @@ struct thp_settings {
 	bool use_zero_page;
 	struct khugepaged_settings khugepaged;
 	unsigned long read_ahead_kb;
+	struct hugepages_settings hugepages[NR_ORDERS];
 };
 
 int read_file(const char *path, char *buf, size_t buflen);
@@ -67,5 +75,6 @@ void thp_restore_settings(void);
 void thp_save_settings(void);
 
 void thp_set_read_ahead_path(char *path);
+unsigned long thp_supported_orders(void);
 
 #endif /* __THP_SETTINGS_H__ */
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-do-not-allow-order-1-folio.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

