Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484FBC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0230921D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633249;
	bh=8DJbTs+l2C1ZpzrNVTCca8+Wku2wNw3bHvhIeAmidOo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=d1ksS8HbSgWfpkKIEsf3dMiB3LaVMaAQdOWEWxN3MSAnr26frxGoWx/A9LCo5i7/d
	 oy1waYzM89AP6V4k5u1KxJcmol0N7lmKyUzyBXEyAbx4p+lXjY1OgmkH5K9i/uKmZI
	 fEAyxtDtR+jdGtvQHQ+QfNsZjBGgYg/vWFlZd5rY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgJMXyI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgJMXyI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAFBE206D5;
        Tue, 13 Oct 2020 23:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633248;
        bh=8DJbTs+l2C1ZpzrNVTCca8+Wku2wNw3bHvhIeAmidOo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Fmbi++F9BsMsEFoZJFexcYu8bxKJr+lOaMfwmmjPpYeurNVfUjTuyG2R8w91HyIlK
         /DJgR+nprrPgzxqLOlmbLrWnh6xanssAAT4uY2xMlU3I78XDNBz6hUAMkLUInyzhaO
         XlTiwRux/11g12auTzTJzAoyKiXr4Q2Vf28YUl40=
Date:   Tue, 13 Oct 2020 16:54:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 105/181] mm/mmap: check on file instead of the
 rb_root_cached of its address_space
Message-ID: <20201013235407.PRKybZHOD%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: check on file instead of the rb_root_cached of its address_space

In __vma_adjust(), we do the check on *root* to decide whether to adjust
the address_space.  It seems to be more meaningful to do the check on
*file* itself.  This means we are adjusting some data because it is a file
backed vma.

Since we seem to assume the address_space is valid if it is a file backed
vma, let's just replace *root* with *file* here.

Link: https://lkml.kernel.org/r/20200913133631.37781-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space
+++ a/mm/mmap.c
@@ -823,7 +823,7 @@ again:
 			anon_vma_interval_tree_pre_update_vma(next);
 	}
 
-	if (root) {
+	if (file) {
 		flush_dcache_mmap_lock(mapping);
 		vma_interval_tree_remove(vma, root);
 		if (adjust_next)
@@ -844,7 +844,7 @@ again:
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
 	}
 
-	if (root) {
+	if (file) {
 		if (adjust_next)
 			vma_interval_tree_insert(next, root);
 		vma_interval_tree_insert(vma, root);
@@ -896,7 +896,7 @@ again:
 		anon_vma_unlock_write(anon_vma);
 	}
 
-	if (root) {
+	if (file) {
 		i_mmap_unlock_write(mapping);
 		uprobe_mmap(vma);
 
_
