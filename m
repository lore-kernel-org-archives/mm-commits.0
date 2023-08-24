Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36B9C3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbjHXXZ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244212AbjHXXYY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF782693
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0994A64774
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616BFC433C9;
        Thu, 24 Aug 2023 23:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919409;
        bh=PZgvYa0GQRZaYqz0NUpCJnAQ2MCaRDR3BxbA90P1UHw=;
        h=Date:To:From:Subject:From;
        b=xgnOpWsqLMOdtyHjGe4chFUCKBZ0tgN3Uyc3bRTkxTyCMKjpNXrOlVBzuUlyCNWYK
         y+7qQURq19MdBeqPBHJBfWbsRtZF2MEb5XBWs/KoqeAQD3OzgSDFy93w0WumvjmZ8V
         SuLu5EMf/vIeVoCmI+kWrZM/GQzfvlScjEA34u/A=
Date:   Thu, 24 Aug 2023 16:23:28 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, bhe@redhat.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-crash-add-x86-crash-hotplug-support-fix.patch removed from -mm tree
Message-Id: <20230824232329.616BFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/crash: correct unused function build error
has been removed from the -mm tree.  Its filename was
     x86-crash-add-x86-crash-hotplug-support-fix.patch

This patch was dropped because it was folded into x86-crash-add-x86-crash-hotplug-support.patch

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: x86/crash: correct unused function build error
Date: Mon, 21 Aug 2023 14:26:44 -0400

In certain config scenarios, an unused-function build error occurs
relating to prepare_elf_headers(). Correct the ifdef guarding these
functions to eliminate the build error.

Link: https://lkml.kernel.org/r/20230821182644.2143-1-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/crash.c~x86-crash-add-x86-crash-hotplug-support-fix
+++ a/arch/x86/kernel/crash.c
@@ -158,7 +158,7 @@ void native_machine_crash_shutdown(struc
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
 
-#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_DUMP)
+#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_HOTPLUG)
 static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
 {
 	unsigned int *nr_ranges = arg;
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
crash-add-generic-infrastructure-for-crash-hotplug-support.patch
kexec-exclude-elfcorehdr-from-the-segment-digest.patch
crash-memory-and-cpu-hotplug-sysfs-attributes.patch
x86-crash-add-x86-crash-hotplug-support.patch
crash-hotplug-support-for-kexec_load.patch
crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
x86-crash-optimize-cpu-changes.patch

