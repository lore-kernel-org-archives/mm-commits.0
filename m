Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516C57580A
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423504; cv=none; b=FSu2zuB1GhpkYEegAmWkQHXK20Ar9kTvUOTVbSHNNkMdNZpDUKFLjb+juMWAE7PMjLcv16EzXEpkwjKjeC+T/BM4XWBFY7XVB+s7yW5nR6FBFjq1ZI1v3JOLhwkBRruC2Ym5TPq2rJ4oEPFs0Qi7onpzv6v/zzdVzXnKLlvY7nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423504; c=relaxed/simple;
	bh=r4V7SlNx+/lGxpvleXfauT6dOI0Uuf/gr0T9+2FQ9cE=;
	h=Date:To:From:Subject:Message-Id; b=A1DQt9a4AJevVLFuS2WD4oa/pKgggBvuzHip9zKECmYiJMpUDZgiBnYzWdj5ztmSe1aZVFw2Kg9nTezdRlAk6+BrfkAkW6mMcwE+ayy+2HKriwl0fkj354+TeshQBO+985EiCOtS2d+O8OFSZ9DjYkvkGPYvAXX+v8m1Y7hDJxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z3wuJlzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z3wuJlzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C4AC4CEC2;
	Wed,  4 Sep 2024 04:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423504;
	bh=r4V7SlNx+/lGxpvleXfauT6dOI0Uuf/gr0T9+2FQ9cE=;
	h=Date:To:From:Subject:From;
	b=z3wuJlzHPZv34hEZFPMplYTgWen5DvDIF41NYj55+SAgNw1zf3WdxNjwf84sbDYql
	 Q4GBMXfpsqUyoqOm9f2ex1fufcHDU5D67BlWwW9OuTyg0fr5PQEp4fSK21i4V4ismA
	 Kl3qshKDxlsCqnGrvc4uRfRTeGJ5Ktqew889jICw=
Date: Tue, 03 Sep 2024 21:18:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-support-shmem-mthp-collapse-testing.patch removed from -mm tree
Message-Id: <20240904041824.28C4AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: support shmem mTHP collapse testing
has been removed from the -mm tree.  Its filename was
     selftests-mm-support-shmem-mthp-collapse-testing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: selftests: mm: support shmem mTHP collapse testing
Date: Tue, 20 Aug 2024 17:49:17 +0800

Add shmem mTHP collpase testing.  Similar to the anonymous page, users can
use the '-s' parameter to specify the shmem mTHP size for testing.

Link: https://lkml.kernel.org/r/fa44bfa20ca5b9fd6f9163a048f3d3c1e53cd0a8.1724140601.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c   |    4 +
 tools/testing/selftests/mm/thp_settings.c |   46 +++++++++++++++++---
 tools/testing/selftests/mm/thp_settings.h |    9 +++
 3 files changed, 51 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-support-shmem-mthp-collapse-testing
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1095,7 +1095,7 @@ static void usage(void)
 	fprintf(stderr,	"\n\tSupported Options:\n");
 	fprintf(stderr,	"\t\t-h: This help message.\n");
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
-	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon allocations.\n");
+	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	exit(1);
 }
 
@@ -1209,6 +1209,8 @@ int main(int argc, char **argv)
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
 	default_settings.hugepages[hpage_pmd_order].enabled = THP_INHERIT;
 	default_settings.hugepages[anon_order].enabled = THP_ALWAYS;
+	default_settings.shmem_hugepages[hpage_pmd_order].enabled = SHMEM_INHERIT;
+	default_settings.shmem_hugepages[anon_order].enabled = SHMEM_ALWAYS;
 
 	save_settings();
 	thp_push_settings(&default_settings);
--- a/tools/testing/selftests/mm/thp_settings.c~selftests-mm-support-shmem-mthp-collapse-testing
+++ a/tools/testing/selftests/mm/thp_settings.c
@@ -33,10 +33,11 @@ static const char * const thp_defrag_str
 };
 
 static const char * const shmem_enabled_strings[] = {
+	"never",
 	"always",
 	"within_size",
 	"advise",
-	"never",
+	"inherit",
 	"deny",
 	"force",
 	NULL
@@ -200,6 +201,7 @@ void thp_write_num(const char *name, uns
 void thp_read_settings(struct thp_settings *settings)
 {
 	unsigned long orders = thp_supported_orders();
+	unsigned long shmem_orders = thp_shmem_supported_orders();
 	char path[PATH_MAX];
 	int i;
 
@@ -234,12 +236,24 @@ void thp_read_settings(struct thp_settin
 		settings->hugepages[i].enabled =
 			thp_read_string(path, thp_enabled_strings);
 	}
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & shmem_orders)) {
+			settings->shmem_hugepages[i].enabled = SHMEM_NEVER;
+			continue;
+		}
+		snprintf(path, PATH_MAX, "hugepages-%ukB/shmem_enabled",
+			(getpagesize() >> 10) << i);
+		settings->shmem_hugepages[i].enabled =
+			thp_read_string(path, shmem_enabled_strings);
+	}
 }
 
 void thp_write_settings(struct thp_settings *settings)
 {
 	struct khugepaged_settings *khugepaged = &settings->khugepaged;
 	unsigned long orders = thp_supported_orders();
+	unsigned long shmem_orders = thp_shmem_supported_orders();
 	char path[PATH_MAX];
 	int enabled;
 	int i;
@@ -271,6 +285,15 @@ void thp_write_settings(struct thp_setti
 		enabled = settings->hugepages[i].enabled;
 		thp_write_string(path, thp_enabled_strings[enabled]);
 	}
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & shmem_orders))
+			continue;
+		snprintf(path, PATH_MAX, "hugepages-%ukB/shmem_enabled",
+			(getpagesize() >> 10) << i);
+		enabled = settings->shmem_hugepages[i].enabled;
+		thp_write_string(path, shmem_enabled_strings[enabled]);
+	}
 }
 
 struct thp_settings *thp_current_settings(void)
@@ -324,17 +347,18 @@ void thp_set_read_ahead_path(char *path)
 	dev_queue_read_ahead_path[sizeof(dev_queue_read_ahead_path) - 1] = '\0';
 }
 
-unsigned long thp_supported_orders(void)
+static unsigned long __thp_supported_orders(bool is_shmem)
 {
 	unsigned long orders = 0;
 	char path[PATH_MAX];
 	char buf[256];
-	int ret;
-	int i;
+	int ret, i;
+	char anon_dir[] = "enabled";
+	char shmem_dir[] = "shmem_enabled";
 
 	for (i = 0; i < NR_ORDERS; i++) {
-		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/enabled",
-			(getpagesize() >> 10) << i);
+		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/%s",
+			       (getpagesize() >> 10) << i, is_shmem ? shmem_dir : anon_dir);
 		if (ret >= PATH_MAX) {
 			printf("%s: Pathname is too long\n", __func__);
 			exit(EXIT_FAILURE);
@@ -347,3 +371,13 @@ unsigned long thp_supported_orders(void)
 
 	return orders;
 }
+
+unsigned long thp_supported_orders(void)
+{
+	return __thp_supported_orders(false);
+}
+
+unsigned long thp_shmem_supported_orders(void)
+{
+	return __thp_supported_orders(true);
+}
--- a/tools/testing/selftests/mm/thp_settings.h~selftests-mm-support-shmem-mthp-collapse-testing
+++ a/tools/testing/selftests/mm/thp_settings.h
@@ -22,10 +22,11 @@ enum thp_defrag {
 };
 
 enum shmem_enabled {
+	SHMEM_NEVER,
 	SHMEM_ALWAYS,
 	SHMEM_WITHIN_SIZE,
 	SHMEM_ADVISE,
-	SHMEM_NEVER,
+	SHMEM_INHERIT,
 	SHMEM_DENY,
 	SHMEM_FORCE,
 };
@@ -46,6 +47,10 @@ struct khugepaged_settings {
 	unsigned long pages_to_scan;
 };
 
+struct shmem_hugepages_settings {
+	enum shmem_enabled enabled;
+};
+
 struct thp_settings {
 	enum thp_enabled thp_enabled;
 	enum thp_defrag thp_defrag;
@@ -54,6 +59,7 @@ struct thp_settings {
 	struct khugepaged_settings khugepaged;
 	unsigned long read_ahead_kb;
 	struct hugepages_settings hugepages[NR_ORDERS];
+	struct shmem_hugepages_settings shmem_hugepages[NR_ORDERS];
 };
 
 int read_file(const char *path, char *buf, size_t buflen);
@@ -76,5 +82,6 @@ void thp_save_settings(void);
 
 void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
+unsigned long thp_shmem_supported_orders(void);
 
 #endif /* __THP_SETTINGS_H__ */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


