Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108DDC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDFE261CD0
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhGHAkm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhGHAkm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BC4E61CCC;
        Thu,  8 Jul 2021 00:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704680;
        bh=LKdlC1gqh7sFCaHzfOo8APULVgOMeJZxXjt1its0xIU=;
        h=Date:From:To:Subject:From;
        b=OqeIzWhjmgFGb6GcxbZLnpK81oJ0Yi9hTZ3PMjsgy/lrHPHs5BGfB290S7TaKFL9M
         1v9JmBaRdQSE/LcJ3j2zn1qE4bXRQs92fVNNkvAa3MGzthHhCEbV0lZKh9Z8IwCVr0
         eTHqDpGKsxzaY1P178SdpfuS+N6BwRe3d0JtjB9I=
Date:   Wed, 07 Jul 2021 17:37:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, lkp@intel.com, swboyd@chromium.org
Subject:  [folded-merged]
 buildid-stash-away-kernels-build-id-on-init-fix.patch removed from -mm tree
Message-ID: <20210708003759.W5a7B%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buildid-stash-away-kernels-build-id-on-init-fix
has been removed from the -mm tree.  Its filename was
     buildid-stash-away-kernels-build-id-on-init-fix.patch

This patch was dropped because it was folded into buildid-stash-away-kernels-build-id-on-init.patch

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: buildid-stash-away-kernels-build-id-on-init-fix

fix implicit declaration of function 'init_vmlinux_build_id'

Link: https://lkml.kernel.org/r/CAE-0n51UjTbay8N9FXAyE7_aR2+ePrQnKSRJ0gbmRsXtcLBVaw@mail.gmail.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/init/main.c~buildid-stash-away-kernels-build-id-on-init-fix
+++ a/init/main.c
@@ -45,6 +45,7 @@
 #include <linux/srcu.h>
 #include <linux/moduleparam.h>
 #include <linux/kallsyms.h>
+#include <linux/buildid.h>
 #include <linux/writeback.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
_

Patches currently in -mm which might be from swboyd@chromium.org are

buildid-only-consider-gnu-notes-for-build-id-parsing.patch
buildid-add-api-to-parse-build-id-out-of-buffer.patch
buildid-stash-away-kernels-build-id-on-init.patch
dump_stack-add-vmlinux-build-id-to-stack-traces.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
arm64-stacktrace-use-%psb-for-backtrace-printing.patch
x86-dumpstack-use-%psb-%pbb-for-backtrace-printing.patch
scripts-decode_stacktracesh-support-debuginfod.patch
scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch
scripts-decode_stacktracesh-indicate-auto-can-be-used-for-base-path.patch
buildid-mark-some-arguments-const.patch
buildid-fix-kernel-doc-notation.patch
kdump-use-vmlinux_build_id-to-simplify.patch

