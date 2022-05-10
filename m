Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF907C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiEJEW7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiEJEUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2AA3C4A0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56D1C6176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BCBC385A6;
        Tue, 10 May 2022 04:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156154;
        bh=/JiXQkwh3at8SDIP1E/TiVA0vrOq0tQEwX7SdRPHGLA=;
        h=Date:To:From:Subject:From;
        b=a0DceLcTt4TA9sQQCKcwVJdMY7DpuhbaByCaXY4oL2SyxlyjiFb6nxUkgUi0rG2C7
         cvWK5j9SOc8P+AMBe3jXO3QeCojwOIz2OtVrgYQ+3sjHsKmdAyoc4ctpTWOvDnBQRc
         FIWfjM8C3I/aJEv7iItVGdsjp6urPZmgG2GeN6AY=
Date:   Mon, 09 May 2022 21:15:54 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-enum-for-state-input-handling.patch removed from -mm tree
Message-Id: <20220510041554.A8BCBC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: use enum for 'state' input handling
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-enum-for-state-input-handling.patch

This patch was dropped because it was merged into mm-stable

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
@@ -2325,23 +2353,47 @@ static int damon_sysfs_update_schemes_st
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


