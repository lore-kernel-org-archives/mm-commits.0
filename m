Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D66C77B7E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjDRXgD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjDRXe6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C3FB46E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9776634A5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357BFC433D2;
        Tue, 18 Apr 2023 23:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860877;
        bh=CfpcizGPo3jeJxPeqv69OGDvJixQhcoL3otJKV0GhpQ=;
        h=Date:To:From:Subject:From;
        b=iGgsZoZD5IyCkLbgvt99DVZ6ZuujmskpxUDcF+E2fVTBh9OsC/wwXaEf0OZxd68e8
         XueVWwGQ3dGO89k/b4lDufGWNMhT8a5PfD6U1ktvcfDDi/pNLcMI9BxEoY6QyG8aMC
         HXfAi6s8e7XgtVYIX4kmxgmoGIzD62JKKC7S5PGo=
Date:   Tue, 18 Apr 2023 16:34:36 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, trix@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-backing-dev-set-variables-dev_attr_minmax_bytes-storage-class-specifier-to-static.patch removed from -mm tree
Message-Id: <20230418233437.357BFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: backing-dev: set variables dev_attr_min,max_bytes storage-class-specifier to static
has been removed from the -mm tree.  Its filename was
     mm-backing-dev-set-variables-dev_attr_minmax_bytes-storage-class-specifier-to-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: mm: backing-dev: set variables dev_attr_min,max_bytes storage-class-specifier to static
Date: Sat, 8 Apr 2023 10:16:09 -0400

smatch reports
mm/backing-dev.c:266:1: warning: symbol
  'dev_attr_min_bytes' was not declared. Should it be static?
mm/backing-dev.c:294:1: warning: symbol
  'dev_attr_max_bytes' was not declared. Should it be static?

These variables are only used in one file so should be static.

Link: https://lkml.kernel.org/r/20230408141609.2703647-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-set-variables-dev_attr_minmax_bytes-storage-class-specifier-to-static
+++ a/mm/backing-dev.c
@@ -263,7 +263,7 @@ static ssize_t min_bytes_store(struct de
 
 	return ret;
 }
-DEVICE_ATTR_RW(min_bytes);
+static DEVICE_ATTR_RW(min_bytes);
 
 static ssize_t max_bytes_show(struct device *dev,
 			      struct device_attribute *attr,
@@ -291,7 +291,7 @@ static ssize_t max_bytes_store(struct de
 
 	return ret;
 }
-DEVICE_ATTR_RW(max_bytes);
+static DEVICE_ATTR_RW(max_bytes);
 
 static ssize_t stable_pages_required_show(struct device *dev,
 					  struct device_attribute *attr,
_

Patches currently in -mm which might be from trix@redhat.com are


