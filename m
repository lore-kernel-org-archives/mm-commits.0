Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC46C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiC2BV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiC2BV4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:21:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CCA2C658
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D06C9611D0
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336AAC340EC;
        Tue, 29 Mar 2022 01:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516814;
        bh=Obx/1J++wTGGhfmHXnP96X7KKmNqdW91paqFbW5S+Ho=;
        h=Date:To:From:Subject:From;
        b=YKQ9XEGJIerpSFIY8GN1WOCR/gU0utP2BhVjnaduBb5JSje5Trbs93V+fYcOGwGi2
         c16ESQ/FzuAOgaV59K+jMBXzVw/jMB+13r9Mq8DkPjQozXEEFbxN1okBczrj2IZ/u2
         d19Ld7S5r1aunMrCRnCxM5zEpgw82MWXs1XHN2I8=
Date:   Mon, 28 Mar 2022 18:20:13 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        mhocko@kernel.org, linmiaohe@huawei.com, david@redhat.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch added to -mm tree
Message-Id: <20220329012014.336AAC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: refactor hotadd_init_pgdat and try_online_node
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/memory_hotplug: refactor hotadd_init_pgdat and try_online_node

Since we pre-allocate all nodes now, hotadd_init_pgdat() does not need to
return a pgdat struct, as that was meant for __try_online_node() to check
whether the node was successfully allocated.

Also get rid of the __ref as all functions hotadd_init_pgdat() calls fall
within the same section.

Also try to make more clear the return codes from __try_online_node(). 
__try_online_node() can return either 0, 1 or -errno (the latter not
really as the BUG_ON() would catch it before we return) but depending on
the caller that has different meanings.

For add_memory_resource(), when __try_online_node() returns non-zero, it
means that the node was already allocated and it does not need to bring it
up.  It is fine not to check for -errno values because we do not get to
call register_one_node() when !set_node_online.  For those who call
try_online_node(), so set_node_online is true, a value other than zero
means a failure (e.g: cpu_up() or find_and_online_cpu_nid()).

Link: https://lkml.kernel.org/r/20220307150725.6810-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node
+++ a/mm/memory_hotplug.c
@@ -1155,8 +1155,7 @@ static void reset_node_present_pages(pg_
 	pgdat->node_present_pages = 0;
 }
 
-/* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-static pg_data_t __ref *hotadd_init_pgdat(int nid)
+static void hotadd_init_pgdat(int nid)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 
@@ -1176,8 +1175,6 @@ static pg_data_t __ref *hotadd_init_pgda
 	 * to access not-initialized zonelist, build here.
 	 */
 	build_all_zonelists(pgdat);
-
-	return pgdat;
 }
 
 /*
@@ -1187,31 +1184,27 @@ static pg_data_t __ref *hotadd_init_pgda
  * called by cpu_up() to online a node without onlined memory.
  *
  * Returns:
- * 1 -> a new node has been allocated
- * 0 -> the node is already online
- * -ENOMEM -> the node could not be allocated
+ * 1 -> The node has been initialized.
+ * 0 -> Either the node was already online, or we succesfully registered a new
+ *      one.
+ * -errno -> register_one_node() failed.
  */
 static int __try_online_node(int nid, bool set_node_online)
 {
-	pg_data_t *pgdat;
-	int ret = 1;
+	int ret;
 
 	if (node_online(nid))
 		return 0;
 
-	pgdat = hotadd_init_pgdat(nid);
-	if (!pgdat) {
-		pr_err("Cannot online node %d due to NULL pgdat\n", nid);
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (set_node_online) {
-		node_set_online(nid);
-		ret = register_one_node(nid);
-		BUG_ON(ret);
-	}
-out:
+	hotadd_init_pgdat(nid);
+
+	if (!set_node_online)
+		return 1;
+
+	node_set_online(nid);
+	ret = register_one_node(nid);
+	BUG_ON(ret);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-untangle-config-dependencies-for-demote-on-reclaim.patch
mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch
mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch

