Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A354C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5438F224BD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgLODQ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgLODPb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:15:31 -0500
Date:   Mon, 14 Dec 2020 19:14:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002091;
        bh=s8q3WCDDzmMAy37A+jENbIVauY6Av9lHihv2t0K1MEA=;
        h=From:To:Subject:In-Reply-To:From;
        b=EJTrFpteiTXdhSiSZ6/Dn0tzcUQHV8yhYRVA1jcIbdvXgr1H4ctMNOJSyQzlNwK2H
         xFOP1ajADR0u/jClizOrzpXVpwpU6CLPJZEG4HfLi7kcR4MqLGdkCD2YB0WiHjP2uM
         4iKUHoGlyGEtxIUWzwUI+wl5r+9yvsyxoBizL1Fk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com,
        gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 196/200] mm:backing-dev: use sysfs_emit in macro
 defining functions
Message-ID: <20201215031450.r2cpddEKh%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: mm:backing-dev: use sysfs_emit in macro defining functions

The cocci script used in commit bdacbb8d04f ("mm: Use sysfs_emit for
struct kobject * uses") does not convert the name##_show macro because the
macro uses concatenation via ##.

Convert it by hand.

Link: https://lkml.kernel.org/r/45ec6cfc177d743f9c0ebaf35e43969dce43af42.1605376435.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-use-sysfs_emit-in-macro-defining-functions
+++ a/mm/backing-dev.c
@@ -150,11 +150,11 @@ static ssize_t read_ahead_kb_store(struc
 
 #define BDI_SHOW(name, expr)						\
 static ssize_t name##_show(struct device *dev,				\
-			   struct device_attribute *attr, char *page)	\
+			   struct device_attribute *attr, char *buf)	\
 {									\
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
 									\
-	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
+	return sysfs_emit(buf, "%lld\n", (long long)expr);		\
 }									\
 static DEVICE_ATTR_RW(name);
 
@@ -200,11 +200,11 @@ BDI_SHOW(max_ratio, bdi->max_ratio)
 
 static ssize_t stable_pages_required_show(struct device *dev,
 					  struct device_attribute *attr,
-					  char *page)
+					  char *buf)
 {
 	dev_warn_once(dev,
 		"the stable_pages_required attribute has been removed. Use the stable_writes queue attribute instead.\n");
-	return snprintf(page, PAGE_SIZE-1, "%d\n", 0);
+	return sysfs_emit(buf, "%d\n", 0);
 }
 static DEVICE_ATTR_RO(stable_pages_required);
 
_
