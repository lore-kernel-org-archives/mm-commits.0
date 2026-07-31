Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FAC33AD9C
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465842; cv=none; b=OiMSFhL/090HjBCiqo9zAaMUjGIaXX4amBZg9Id4f0IN43kqX46sy61U9JI+GuTocc00JdWJjAqrGBkqdeHQEjHIPB+XqMOsN4d4NlDbICBgCnlbMDFClDV5wMdpFfEOm6kZHww5p7hKXoTAX4rQ4OyWCKUEG9J5Hxv+IPoy06U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465842; c=relaxed/simple;
	bh=nbuxI6kxZh/aAmFruP7LWJgnBlRbLXrfQW+XkY3XUZw=;
	h=Date:To:From:Subject:Message-Id; b=BUQntkzXIX3ushAhx/fqaVWtK8wGFFMrlua2T3F+w1qkB5nEBEVLjtJr/cx8arE8i+WIpYfhg85wxFKJF6/0D4Rt4lnUAGp0AB64ATZGZUUghnqsG8FhyOeTE2K04WjiqfgEJw+73i6YmBGEPAJZrKomC86CiyVOljiHcv74YDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fU4I9P5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fU4I9P5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1CD1F000E9;
	Fri, 31 Jul 2026 02:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465841;
	bh=aZvQNm5EGMCJXaeoFL7ZsDITET0fuQo3shm2hD53CCw=;
	h=Date:To:From:Subject;
	b=fU4I9P5paqU0UirdNe+xFwNhdwz33zuPMNrsX3TbXCfCRo/ZA2peqQbMq5fyfHer5
	 aV/pEPd9AWlVpQ5lub25gVUPZlrkUrJJceIv2kpXWd9BeDMhAOkDl9/+2/kb0E7/9+
	 jLgQqOYtzSxl/AqhuWaLa+qJJq7ID5T+uoP05LWo=
Date: Thu, 30 Jul 2026 19:44:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vishal.moola@gmail.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page_owner_sort-bound-pattern-output-copies.patch removed from -mm tree
Message-Id: <20260731024401.3D1CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page_owner_sort: bound pattern output copies
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sort-bound-pattern-output-copies.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: tools/mm/page_owner_sort: bound pattern output copies
Date: Mon, 29 Jun 2026 09:43:16 +0800

search_pattern() copies a regex capture into caller-provided buffers
without knowing their sizes.  Several callers pass fixed-size buffers,
including FIELD_BUFF and TASK_COMM_LEN.

Pass the destination size to search_pattern(), reject captures that do not
fit before copying them, and terminate the output string inside
search_pattern().

Link: https://lore.kernel.org/20260629014316.130307-4-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Cc: Vishal Moola <vishal.moola@gmail.com>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-bound-pattern-output-copies
+++ a/tools/mm/page_owner_sort.c
@@ -237,7 +237,8 @@ static int remove_pattern(regex_t *patte
 	return len - (pmatch[1].rm_eo - pmatch[1].rm_so);
 }
 
-static int search_pattern(regex_t *pattern, char *pattern_str, char *buf)
+static int search_pattern(regex_t *pattern, char *pattern_str,
+			  size_t pattern_str_size, char *buf)
 {
 	int err, val_len;
 	regmatch_t pmatch[2];
@@ -249,8 +250,14 @@ static int search_pattern(regex_t *patte
 		return -1;
 	}
 	val_len = pmatch[1].rm_eo - pmatch[1].rm_so;
+	if ((size_t)val_len >= pattern_str_size) {
+		if (debug_on)
+			fprintf(stderr, "pattern too long in %s\n", buf);
+		return -1;
+	}
 
 	memcpy(pattern_str, buf + pmatch[1].rm_so, val_len);
+	pattern_str[val_len] = '\0';
 
 	return 0;
 }
@@ -307,7 +314,8 @@ static int get_page_num(char *buf)
 	char order_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&order_pattern, order_str, buf);
+	if (search_pattern(&order_pattern, order_str, sizeof(order_str), buf) < 0)
+		return 0;
 	errno = 0;
 	order_val = strtol(order_str, &endptr, 10);
 	if (order_val > 64 || errno != 0 || endptr == order_str || *endptr != '\0') {
@@ -325,7 +333,8 @@ static pid_t get_pid(char *buf)
 	char pid_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&pid_pattern, pid_str, buf);
+	if (search_pattern(&pid_pattern, pid_str, sizeof(pid_str), buf) < 0)
+		return -1;
 	errno = 0;
 	pid = strtol(pid_str, &endptr, 10);
 	if (errno != 0 || endptr == pid_str || *endptr != '\0') {
@@ -344,7 +353,8 @@ static pid_t get_tgid(char *buf)
 	char tgid_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&tgid_pattern, tgid_str, buf);
+	if (search_pattern(&tgid_pattern, tgid_str, sizeof(tgid_str), buf) < 0)
+		return -1;
 	errno = 0;
 	tgid = strtol(tgid_str, &endptr, 10);
 	if (errno != 0 || endptr == tgid_str || *endptr != '\0') {
@@ -363,7 +373,9 @@ static __u64 get_ts_nsec(char *buf)
 	char ts_nsec_str[FIELD_BUFF] = {0};
 	char *endptr;
 
-	search_pattern(&ts_nsec_pattern, ts_nsec_str, buf);
+	if (search_pattern(&ts_nsec_pattern, ts_nsec_str,
+			   sizeof(ts_nsec_str), buf) < 0)
+		return -1;
 	errno = 0;
 	ts_nsec = strtoull(ts_nsec_str, &endptr, 10);
 	if (errno != 0 || endptr == ts_nsec_str || *endptr != '\0') {
@@ -384,7 +396,10 @@ static char *get_comm(char *buf)
 
 	memset(comm_str, 0, TASK_COMM_LEN);
 
-	search_pattern(&comm_pattern, comm_str, buf);
+	if (search_pattern(&comm_pattern, comm_str, TASK_COMM_LEN, buf) < 0) {
+		free(comm_str);
+		return NULL;
+	}
 	errno = 0;
 	if (errno != 0) {
 		if (debug_on)
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

hugetlbfs-release-subpool-on-fill_super-failure.patch
hugetlb-make-hugepage_put_subpool-tolerate-null.patch
hugetlb-evaluate-subpool-free-state-while-locked.patch
fat-release-buffer-head-after-rebuilding-parent.patch

