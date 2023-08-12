Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EE3C04FE2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjHLWF7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjHLWFq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E562419B1
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85D2C61169
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7278C433C7;
        Sat, 12 Aug 2023 22:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877940;
        bh=QbWRmCzBbqLyKhuPu1N90ik1NuYlywmpQF52T5BBsNc=;
        h=Date:To:From:Subject:From;
        b=ikFJu26EhG75H4iu6mcHtT4KhiuCLjcAgpUZywCyRVqCr2KHrEKb4cK+92zqk8IEd
         827uuV0mKkY+tmEASytbwawisC3wPwtqm9dnmjii5N5mf8GOU31E9qYdxoDkwdr0Ae
         hL7d9U8xx52qYbXjW4iW/Hk3tx4BWOG5jPUxiDBE=
Date:   Sat, 12 Aug 2023 15:05:40 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        kunyu@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-relay-remove-unnecessary-null-values-from-relay_open_buf.patch removed from -mm tree
Message-Id: <20230812220540.D7278C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel: relay: remove unnecessary NULL values from relay_open_buf
has been removed from the -mm tree.  Its filename was
     kernel-relay-remove-unnecessary-null-values-from-relay_open_buf.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li kunyu <kunyu@nfschina.com>
Subject: kernel: relay: remove unnecessary NULL values from relay_open_buf
Date: Fri, 14 Jul 2023 07:44:59 +0800

buf is assigned first, so it does not need to initialize the assignment.

Link: https://lkml.kernel.org/r/20230713234459.2908-1-kunyu@nfschina.com
Signed-off-by: Li kunyu <kunyu@nfschina.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/relay.c~kernel-relay-remove-unnecessary-null-values-from-relay_open_buf
+++ a/kernel/relay.c
@@ -375,7 +375,7 @@ static struct dentry *relay_create_buf_f
  */
 static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
 {
- 	struct rchan_buf *buf = NULL;
+	struct rchan_buf *buf;
 	struct dentry *dentry;
 
  	if (chan->is_global)
_

Patches currently in -mm which might be from kunyu@nfschina.com are


