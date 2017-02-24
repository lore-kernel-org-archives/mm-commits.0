From: akpm@linux-foundation.org
Subject: [patch 006/124] mm/memory_hotplug.c: unexport __remove_pages()
Date: Fri, 24 Feb 2017 14:55:51 -0800
Message-ID: <58b0b9f7.KRUYikgESNLBae9e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXWzw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:55:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dan.j.williams@intel.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memory_hotplug.c: unexport __remove_pages()

It has no modular callers.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-unexport-__remove_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-unexport-__remove_pages
+++ a/mm/memory_hotplug.c
@@ -864,7 +864,6 @@ int __remove_pages(struct zone *zone, un
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__remove_pages);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 int set_online_page_callback(online_page_callback_t callback)
_
