Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06935C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01C3611CB
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347663AbhIIVFe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347719AbhIIVE3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FBFD611C5;
        Thu,  9 Sep 2021 21:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221399;
        bh=o6znESMYzwo5P2AkjhEl/bobyLd+Lq9Bxt26cqxEDZ0=;
        h=Date:From:To:Subject:From;
        b=D4hqFJJsBYfWKADCJcmTp+ZFgsVbdxth4PttoDRzG85n7VgVbujT4riZskowVZrjx
         a64QV8yQ3V5BnfOt+nrF4D/y3nflw1IiWv05fXxEn859hy66lpniysa9uP6y+4uFk2
         txuaXAgU4aEPbJsLL6dZJRYdkqpbYOGvEtLNlUFU=
Date:   Thu, 09 Sep 2021 14:03:19 -0700
From:   akpm@linux-foundation.org
To:     ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net
Subject:  [merged]
 alpha-pci-sysfs-fix-all-kernel-doc-warnings.patch removed from -mm tree
Message-ID: <20210909210319.Bc41Niw27%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: pci-sysfs: fix all kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     alpha-pci-sysfs-fix-all-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: alpha: pci-sysfs: fix all kernel-doc warnings

Fix all kernel-doc warnings in arch/alpha/kernel/pci-sysfs.c:

../arch/alpha/kernel/pci-sysfs.c:67: warning: No description found for return value of 'pci_mmap_resource'
../arch/alpha/kernel/pci-sysfs.c:115: warning: Function parameter or member 'pdev' not described in 'pci_remove_resource_files'
../arch/alpha/kernel/pci-sysfs.c:115: warning: Excess function parameter 'dev' description in 'pci_remove_resource_files'
../arch/alpha/kernel/pci-sysfs.c:230: warning: Function parameter or member 'pdev' not described in 'pci_create_resource_files'
../arch/alpha/kernel/pci-sysfs.c:230: warning: Excess function parameter 'dev' description in 'pci_create_resource_files'
../arch/alpha/kernel/pci-sysfs.c:232: warning: No description found for return value of 'pci_create_resource_files'
../arch/alpha/kernel/pci-sysfs.c:305: warning: Function parameter or member 'bus' not described in 'pci_adjust_legacy_attr'
../arch/alpha/kernel/pci-sysfs.c:305: warning: Excess function parameter 'b' description in 'pci_adjust_legacy_attr'

Link: https://lkml.kernel.org/r/20210808185249.31442-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci-sysfs.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/alpha/kernel/pci-sysfs.c~alpha-pci-sysfs-fix-all-kernel-doc-warnings
+++ a/arch/alpha/kernel/pci-sysfs.c
@@ -60,6 +60,8 @@ static int __pci_mmap_fits(struct pci_de
  * @sparse: address space type
  *
  * Use the bus mapping routines to map a PCI resource into userspace.
+ *
+ * Return: %0 on success, negative error code otherwise
  */
 static int pci_mmap_resource(struct kobject *kobj,
 			     struct bin_attribute *attr,
@@ -106,7 +108,7 @@ static int pci_mmap_resource_dense(struc
 
 /**
  * pci_remove_resource_files - cleanup resource files
- * @dev: dev to cleanup
+ * @pdev: pci_dev to cleanup
  *
  * If we created resource files for @dev, remove them from sysfs and
  * free their resources.
@@ -221,10 +223,12 @@ static int pci_create_attr(struct pci_de
 }
 
 /**
- * pci_create_resource_files - create resource files in sysfs for @dev
- * @dev: dev in question
+ * pci_create_resource_files - create resource files in sysfs for @pdev
+ * @pdev: pci_dev in question
  *
  * Walk the resources in @dev creating files for each resource available.
+ *
+ * Return: %0 on success, or negative error code
  */
 int pci_create_resource_files(struct pci_dev *pdev)
 {
@@ -296,7 +300,7 @@ int pci_mmap_legacy_page_range(struct pc
 
 /**
  * pci_adjust_legacy_attr - adjustment of legacy file attributes
- * @b: bus to create files under
+ * @bus: bus to create files under
  * @mmap_type: I/O port or memory
  *
  * Adjust file name and size for sparse mappings.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


