Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DD5C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AFA96146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhGAB5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB5I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF7EB61418;
        Thu,  1 Jul 2021 01:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104479;
        bh=fRvBNWulQUko4aPaQqRgmopGLIhUL/UCkKdhIKskUfc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=blizlUI6AJeKi8buonZMv6YsGoqH6P/ttq+yyg1qw9H1itlzVXRvFXxCf/wzvBQSF
         4bpNWA2CaD5oPBmTf9bsThQePY+g/djfoZt2dxXMmhoQqGK9Yol0Oh8yhuiH2u7185
         0e6ev8Nc2X9Ei6/zsCNifQ8aUxYGemvM3JJD9H2I=
Date:   Wed, 30 Jun 2021 18:54:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        cascardo@canonical.com, christian.brauner@ubuntu.com,
        ddiss@suse.de, deller@gmx.de, linux-mm@kvack.org,
        lstoakes@gmail.com, marcelo.cerri@canonical.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        torvalds@linux-foundation.org, walken@google.com
Subject:  [patch 140/192] proc: Avoid mixing integer types in
 mem_rw()
Message-ID: <20210701015438.0zNDxEvkA%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: proc: Avoid mixing integer types in mem_rw()

Use size_t when capping the count argument received by mem_rw(). Since
count is size_t, using min_t(int, ...) can lead to a negative value
that will later be passed to access_remote_vm(), which can cause
unexpected behavior.

Since we are capping the value to at maximum PAGE_SIZE, the conversion
from size_t to int when passing it to access_remote_vm() as "len"
shouldn't be a problem.

Link: https://lkml.kernel.org/r/20210512125215.3348316-1-marcelo.cerri@canonical.com
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Souza Cascardo <cascardo@canonical.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~proc-avoid-mixing-integer-types-in-mem_rw
+++ a/fs/proc/base.c
@@ -854,7 +854,7 @@ static ssize_t mem_rw(struct file *file,
 	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
 
 	while (count > 0) {
-		int this_len = min_t(int, count, PAGE_SIZE);
+		size_t this_len = min_t(size_t, count, PAGE_SIZE);
 
 		if (write && copy_from_user(page, buf, this_len)) {
 			copied = -EFAULT;
_
