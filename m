Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76425C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379068AbiD2Q3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379066AbiD2Q3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87377D4C4E
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CFC962241
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D69C385A7;
        Fri, 29 Apr 2022 16:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249567;
        bh=KS6FcZjo2JDXlhak/1ANOeAJevt/JKeddhmkprzLnoo=;
        h=Date:To:From:Subject:From;
        b=vUPjVFgu7m7fLoF0m9HR86KUUzTkqmbQMZg9A8bEeIlY8Kjs1Hoa2g/Zu+j4jkr/J
         vZ4AO/Iruop/Sh21r9qDTb2SRVI9n3u3RMKh/01QYRaJOk28zpDObqMXWi7tU1/OtN
         pt/Blsqy4/ysaLI5YIUchSn7NJYWTZk8JbOiWRMA=
Date:   Fri, 29 Apr 2022 09:26:06 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-enum-for-state-input-handling.patch added to mm-unstable branch
Message-Id: <20220429162607.74D69C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: use enum for 'state' input handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-use-enum-for-state-input-handling.patch

This patch should soon appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use enum for 'state' input handling

DAMON sysfs 'state' file handling code is using string literals in both
'state_show()' and 'state_store()'.  This makes the code error prone and
inflexible for future extensions.

To improve the situation, this commit defines possible input strings and
'enum' for identifying each input keyword only once, and refactors the
code to reuse those.

Link: https://lkml.kernel.org/r/20220429160606.127307-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   72 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 10 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-enum-for-state-input-handling
+++ a/mm/damon/sysfs.c
@@ -2053,6 +2053,32 @@ static bool damon_sysfs_ctx_running(stru
 	return running;
 }
 
+/*
+ * enum damon_sysfs_cmd - Commands for a specific kdamond.
+ */
+enum damon_sysfs_cmd {
+	/* @DAMON_SYSFS_CMD_ON: Turn the kdamond on. */
+	DAMON_SYSFS_CMD_ON,
+	/* @DAMON_SYSFS_CMD_OFF: Turn the kdamond off. */
+	DAMON_SYSFS_CMD_OFF,
+	/*
+	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS: Update scheme stats sysfs
+	 * files.
+	 */
+	DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS,
+	/*
+	 * @NR_DAMON_SYSFS_CMDS: Total number of DAMON sysfs commands.
+	 */
+	NR_DAMON_SYSFS_CMDS,
+};
+
+/* Should match with enum damon_sysfs_cmd */
+static const char * const damon_sysfs_cmd_strs[] = {
+	"on",
+	"off",
+	"update_schemes_stats",
+};
+
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
@@ -2066,7 +2092,9 @@ static ssize_t state_show(struct kobject
 	else
 		running = damon_sysfs_ctx_running(ctx);
 
-	return sysfs_emit(buf, "%s\n", running ? "on" : "off");
+	return sysfs_emit(buf, "%s\n", running ?
+			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
+			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_OFF]);
 }
 
 static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
@@ -2324,23 +2352,47 @@ static int damon_sysfs_update_schemes_st
 	return 0;
 }
 
+/*
+ * damon_sysfs_handle_cmd() - Handle a command for a specific kdamond.
+ * @cmd:	The command to handle.
+ * @kdamond:	The kobject wrapper for the associated kdamond.
+ *
+ * This function handles a DAMON sysfs command for a kdamond.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
+		struct damon_sysfs_kdamond *kdamond)
+{
+	switch (cmd) {
+	case DAMON_SYSFS_CMD_ON:
+		return damon_sysfs_turn_damon_on(kdamond);
+	case DAMON_SYSFS_CMD_OFF:
+		return damon_sysfs_turn_damon_off(kdamond);
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
+		return damon_sysfs_update_schemes_stats(kdamond);
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
 static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
 			struct damon_sysfs_kdamond, kobj);
-	ssize_t ret;
+	enum damon_sysfs_cmd cmd;
+	ssize_t ret = -EINVAL;
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
-	if (sysfs_streq(buf, "on"))
-		ret = damon_sysfs_turn_damon_on(kdamond);
-	else if (sysfs_streq(buf, "off"))
-		ret = damon_sysfs_turn_damon_off(kdamond);
-	else if (sysfs_streq(buf, "update_schemes_stats"))
-		ret = damon_sysfs_update_schemes_stats(kdamond);
-	else
-		ret = -EINVAL;
+	for (cmd = 0; cmd < NR_DAMON_SYSFS_CMDS; cmd++) {
+		if (sysfs_streq(buf, damon_sysfs_cmd_strs[cmd])) {
+			ret = damon_sysfs_handle_cmd(cmd, kdamond);
+			break;
+		}
+	}
 	mutex_unlock(&damon_sysfs_lock);
 	if (!ret)
 		ret = count;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-core-add-a-new-callback-for-watermarks-checks.patch
mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch
mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch
mm-damon-vaddr-move-damon_set_regions-to-core.patch
mm-damon-vaddr-remove-damon_va_apply_three_regions.patch
mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch
mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch
mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch
mm-damon-sysfs-use-enum-for-state-input-handling.patch
mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch
mm-damon-sysfs-support-online-inputs-update.patch
docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch
mm-damon-reclaim-support-online-inputs-update.patch
docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch

