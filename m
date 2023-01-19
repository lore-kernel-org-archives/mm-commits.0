Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8FBC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjASBWP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjASBUF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC254903B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 780FA61B0B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78D5C433EF;
        Thu, 19 Jan 2023 01:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091012;
        bh=/Z8E1JEzT4htElHWE346ComZXoB+Vr5S73LVfp9U2Fg=;
        h=Date:To:From:Subject:From;
        b=HsVEOGY8aNYUNauSjicPsKU4K++aZJMecA02z9Me/5LJbX9+kD1vDbYaDWuJ0edmt
         cHwFnvWs23EwXfURt/uvp/UlmyCIU6h3/kVdDcJzQgsQEVxtQr7/YvVk4mli4VvSzK
         XyDPbheghUBEEossGtkJGzcEMeeCSf0IHrYikXk0=
Date:   Wed, 18 Jan 2023 17:16:52 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn, sj@kernel.org,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-use-strscpy-to-instead-of-strncpy.patch removed from -mm tree
Message-Id: <20230119011652.D78D5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: use strscpy() to instead of strncpy()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-use-strscpy-to-instead-of-strncpy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xu Panda <xu.panda@zte.com.cn>
Subject: mm/damon/sysfs-schemes: use strscpy() to instead of strncpy()
Date: Mon, 9 Jan 2023 19:46:55 +0800 (CST)

The implementation of strscpy() is more robust and safer.
That's now the recommended way to copy NUL-terminated strings.

Link: https://lkml.kernel.org/r/202301091946553770006@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-use-strscpy-to-instead-of-strncpy
+++ a/mm/damon/sysfs-schemes.c
@@ -353,8 +353,7 @@ static ssize_t memcg_path_store(struct k
 	if (!path)
 		return -ENOMEM;
 
-	strncpy(path, buf, count);
-	path[count] = '\0';
+	strscpy(path, buf, count + 1);
 	filter->memcg_path = path;
 	return count;
 }
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are


