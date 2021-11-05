Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E33CC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C22B61288
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhKEUqz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhKEUqz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5656126A;
        Fri,  5 Nov 2021 20:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145055;
        bh=7ExTBo8yYOKPEJWgDS9yxNslGfYJtk79DkBlhAcDYfg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WDHw0mpk8ZZH9pJS9z1D1XqcLkmLvvfhmoxsy3SVWrUQt7XxtTML/MquqaWEDU80U
         fqxSlKcMM7CSwrC2weIq3EGKowrNCVwg3LlPuN1K3EuFHU9xvIn8F2YfQ5tvJlabJN
         Gx16elWg5db41vBfkYyD+NqRmr4efCBXEF2t8JRU=
Date:   Fri, 05 Nov 2021 13:44:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 184/262] memory-hotplug.rst: fix wrong
 /sys/module/memory_hotplug/parameters/ path
Message-ID: <20211105204414.4-fXcG8Jq%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path

We accidentially added a superfluous "s".

Link: https://lkml.kernel.org/r/20210930144117.23641-3-david@redhat.com
Fixes: ac3332c44767 ("memory-hotplug.rst: complete admin-guide overhaul")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -410,7 +410,7 @@ them with ``memory_hotplug.`` such as::
 
 and they can be observed (and some even modified at runtime) via::
 
-	/sys/modules/memory_hotplug/parameters/
+	/sys/module/memory_hotplug/parameters/
 
 The following module parameters are currently defined:
 
_
