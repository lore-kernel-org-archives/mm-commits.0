Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9D3C43217
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345364AbiCWXHI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345374AbiCWXHH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208709025D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:05:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B19A3617E9
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11168C340E8;
        Wed, 23 Mar 2022 23:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076736;
        bh=EWf/JA9q+bf+8thitxZGoc9ImQ460I+csfS/3/cvfmo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=UpR9VH4x3Xa5I7MS72ar7Ds+QYlpwHiqUOO55H680R5V2SmT0sHO2WQV/Ec42PbEh
         9S5wZLZxCsvO3OzBZIfAvvvFS1yf8PkfIobho7Kz3F7vuGULDb2lMGPAVe6vM0kq4b
         e/zVrGNrZwX8J+5bAjp2calItDZriJJcqTM4XCaE=
Date:   Wed, 23 Mar 2022 16:05:35 -0700
To:     gregkh@linuxfoundation.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 06/41] kernel/ksysfs.c: use helper macro __ATTR_RW
Message-Id: <20220323230536.11168C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: kernel/ksysfs.c: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define kobj_attribute to make code more
clear.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220222112034.48298-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/ksysfs.c~kernel-ksysfsc-use-helper-macro-__attr_rw
+++ a/kernel/ksysfs.c
@@ -24,8 +24,7 @@
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
 #define KERNEL_ATTR_RW(_name) \
-static struct kobj_attribute _name##_attr = \
-	__ATTR(_name, 0644, _name##_show, _name##_store)
+static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 /* current uevent sequence number */
 static ssize_t uevent_seqnum_show(struct kobject *kobj,
_
