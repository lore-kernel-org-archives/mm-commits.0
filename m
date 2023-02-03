Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEC4C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjBCGwd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjBCGvb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13718E04A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58221B82986
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC239C433EF;
        Fri,  3 Feb 2023 06:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407082;
        bh=kukOgDr9uCq9fbg+PWjt7TB38fD69UBQtrUvfKIzQcM=;
        h=Date:To:From:Subject:From;
        b=uCBHXzi3glhLs2RcDf7L7hJQqEGzitX1PVIbeGq/ZpKcxVK6GQKXOWt/qvi5D6Gjq
         dbg10IicOouF2vvbqvUTdtFNAbhwgVp9pNleGaJ3EsBnJIJjMzKxDOrXBC2Amq4bPF
         wmT5RRNjBD2k/p1P37LWhyfJOg8muXJqr48921RU=
Date:   Thu, 02 Feb 2023 22:51:21 -0800
To:     mm-commits@vger.kernel.org, luca.ceresoli@bootlin.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances.patch removed from -mm tree
Message-Id: <20230203065121.EC239C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/spelling.txt: add "exsits" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: scripts/spelling.txt: add "exsits" pattern and fix typo instances
Date: Thu, 26 Jan 2023 16:22:05 +0100

Fix typos and add the following to the scripts/spelling.txt:

  exsits||exists

Link: https://lkml.kernel.org/r/20230126152205.959277-1-luca.ceresoli@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/infiniband/ulp/iser/iscsi_iser.c~scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances
+++ a/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -446,7 +446,7 @@ iscsi_iser_conn_create(struct iscsi_cls_
  * @is_leading:      indicate if this is the session leading connection (MCS)
  *
  * Return: zero on success, $error if iscsi_conn_bind fails and
- *         -EINVAL in case end-point doesn't exsits anymore or iser connection
+ *         -EINVAL in case end-point doesn't exists anymore or iser connection
  *         state is not UP (teardown already started).
  */
 static int iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
--- a/net/openvswitch/flow_table.c~scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances
+++ a/net/openvswitch/flow_table.c
@@ -1012,7 +1012,7 @@ static int flow_mask_insert(struct flow_
 
 	mask = flow_mask_find(tbl, new);
 	if (!mask) {
-		/* Allocate a new mask if none exsits. */
+		/* Allocate a new mask if none exists. */
 		mask = mask_alloc();
 		if (!mask)
 			return -ENOMEM;
--- a/scripts/spelling.txt~scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -630,6 +630,7 @@ exeuction||execution
 existance||existence
 existant||existent
 exixt||exist
+exsits||exists
 exlcude||exclude
 exlcusive||exclusive
 exlusive||exclusive
--- a/sound/soc/fsl/fsl-asoc-card.c~scripts-spellingtxt-add-exsits-pattern-and-fix-typo-instances
+++ a/sound/soc/fsl/fsl-asoc-card.c
@@ -811,7 +811,7 @@ static int fsl_asoc_card_probe(struct pl
 	priv->card.num_links = 1;
 
 	if (asrc_pdev) {
-		/* DPCM DAI Links only if ASRC exsits */
+		/* DPCM DAI Links only if ASRC exists */
 		priv->dai_link[1].cpus->of_node = asrc_np;
 		priv->dai_link[1].platforms->of_node = asrc_np;
 		priv->dai_link[2].codecs->dai_name = codec_dai_name;
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are


