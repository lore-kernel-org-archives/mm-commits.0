Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1BBC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiEJEWl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbiEJEUf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F064A2AD771
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C0366176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D77C385C5;
        Tue, 10 May 2022 04:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156130;
        bh=pBaiSn8NrH/Ii4Q7kgjkxx1hHxb7tVjRk42ZpSQea4w=;
        h=Date:To:From:Subject:From;
        b=aHePHGn4dNr/I9dNM43gLaranVEjz6TXMtfRJQ4dVPSumBJYx8lW1bVpu90FrkoZ/
         5ryVbClHii8zImoMc3hUmP6Pu/rVeMQdS1v7xxqZlaQ7DlA2j4T3FBk03C1p6sWS2k
         Hu2O/ue2yiTPVn6D4rA8Ui3hLVlL6efMx1nFFpWM=
Date:   Mon, 09 May 2022 21:15:29 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch removed from -mm tree
Message-Id: <20220510041529.E1D77C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: add a function for damon_operations registration checks
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add a function for damon_operations registration checks

Patch series "mm/damon: allow users know which monitoring ops are available".

DAMON users can configure it for vaious address spaces including virtual
address spaces and the physical address space by setting its monitoring
operations set with appropriate one for their purpose.  However, there is
no celan and simple way to know exactly which monitoring operations sets
are available on the currently running kernel.

This patchset adds functions for the purpose on DAMON's kernel API
('damon_is_registered_ops()') and sysfs interface ('avail_operations' file
under each context directory).


This patch (of 4):

To know if a specific 'damon_operations' is registered, users need to
check the kernel config or try 'damon_select_ops()' with the ops of the
question, and then see if it successes.  In the latter case, the user
should also revert the change.  To make the process simple and convenient,
this commit adds a function for checking if a specific 'damon_operations'
is registered or not.

Link: https://lkml.kernel.org/r/20220426203843.45238-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220426203843.45238-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |   24 +++++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-a-function-for-damon_operations-registration-checks
+++ a/include/linux/damon.h
@@ -509,6 +509,7 @@ int damon_set_attrs(struct damon_ctx *ct
 int damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
 int damon_nr_running_ctxs(void);
+bool damon_is_registered_ops(enum damon_ops_id id);
 int damon_register_ops(struct damon_operations *ops);
 int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
 
--- a/mm/damon/core.c~mm-damon-core-add-a-function-for-damon_operations-registration-checks
+++ a/mm/damon/core.c
@@ -30,7 +30,7 @@ static DEFINE_MUTEX(damon_ops_lock);
 static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
-static bool damon_registered_ops_id(enum damon_ops_id id)
+static bool __damon_is_registered_ops(enum damon_ops_id id)
 {
 	struct damon_operations empty_ops = {};
 
@@ -40,6 +40,24 @@ static bool damon_registered_ops_id(enum
 }
 
 /**
+ * damon_is_registered_ops() - Check if a given damon_operations is registered.
+ * @id:	Id of the damon_operations to check if registered.
+ *
+ * Return: true if the ops is set, false otherwise.
+ */
+bool damon_is_registered_ops(enum damon_ops_id id)
+{
+	bool registered;
+
+	if (id >= NR_DAMON_OPS)
+		return false;
+	mutex_lock(&damon_ops_lock);
+	registered = __damon_is_registered_ops(id);
+	mutex_unlock(&damon_ops_lock);
+	return registered;
+}
+
+/**
  * damon_register_ops() - Register a monitoring operations set to DAMON.
  * @ops:	monitoring operations set to register.
  *
@@ -56,7 +74,7 @@ int damon_register_ops(struct damon_oper
 		return -EINVAL;
 	mutex_lock(&damon_ops_lock);
 	/* Fail for already registered ops */
-	if (damon_registered_ops_id(ops->id)) {
+	if (__damon_is_registered_ops(ops->id)) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -84,7 +102,7 @@ int damon_select_ops(struct damon_ctx *c
 		return -EINVAL;
 
 	mutex_lock(&damon_ops_lock);
-	if (!damon_registered_ops_id(id))
+	if (!__damon_is_registered_ops(id))
 		err = -EINVAL;
 	else
 		ctx->ops = damon_registered_ops[id];
_

Patches currently in -mm which might be from sj@kernel.org are


