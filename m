Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F74C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E309061448
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEHWyn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhEHWym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3BF961432;
        Sat,  8 May 2021 22:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514420;
        bh=+3jPoDQh3gHRZCQJYNUUuQLD2CpqRnpHQNzx4rLTn0k=;
        h=Date:From:To:Subject:From;
        b=jhljmXmc6EwPP3DfWOeIcI0jnm/Vam86IuVopZWic13kMA5kmt2vXPvfP1BQNmOZX
         Msds8IQR4viOeEdg4fm3n92RAgM7xOcA0g6RqIWnDVQKmGnbi5hvfYbJVkoYNhAAav
         4Da6EV7R3KqDeyfV8/5QEK8MytNIF1A11DeEN6jA=
Date:   Sat, 08 May 2021 15:53:39 -0700
From:   akpm@linux-foundation.org
To:     anton@enomsg.org, bhe@redhat.com, bhsharma@redhat.com,
        ccross@android.com, ebiederm@xmission.com, jmorris@namei.org,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, pmladek@suse.com, sashal@kernel.org,
        tony.luck@intel.com, tyhicks@linux.microsoft.com
Subject:  [merged] kexec-dump-kmessage-before-machine_kexec.patch
 removed from -mm tree
Message-ID: <20210508225339.77BuvZ-0r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: dump kmessage before machine_kexec
has been removed from the -mm tree.  Its filename was
     kexec-dump-kmessage-before-machine_kexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: kexec: dump kmessage before machine_kexec

kmsg_dump(KMSG_DUMP_SHUTDOWN) is called before
machine_restart(), machine_halt(), machine_power_off(), the only one that
is missing is  machine_kexec().

The dmesg output that it contains can be used to study the shutdown
performance of both kernel and systemd during kexec reboot.

Here is example of dmesg data collected after kexec:

root@dplat-cp22:~# cat /sys/fs/pstore/dmesg-ramoops-0 | tail
...
<6>[   70.914592] psci: CPU3 killed (polled 0 ms)
<5>[   70.915705] CPU4: shutdown
<6>[   70.916643] psci: CPU4 killed (polled 4 ms)
<5>[   70.917715] CPU5: shutdown
<6>[   70.918725] psci: CPU5 killed (polled 0 ms)
<5>[   70.919704] CPU6: shutdown
<6>[   70.920726] psci: CPU6 killed (polled 4 ms)
<5>[   70.921642] CPU7: shutdown
<6>[   70.922650] psci: CPU7 killed (polled 0 ms)

Link: https://lkml.kernel.org/r/20210319192326.146000-2-pasha.tatashin@soleen.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Bhupesh Sharma <bhsharma@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: James Morris <jmorris@namei.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kexec_core.c~kexec-dump-kmessage-before-machine_kexec
+++ a/kernel/kexec_core.c
@@ -37,6 +37,7 @@
 #include <linux/compiler.h>
 #include <linux/hugetlb.h>
 #include <linux/objtool.h>
+#include <linux/kmsg_dump.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -1179,6 +1180,7 @@ int kernel_kexec(void)
 		machine_shutdown();
 	}
 
+	kmsg_dump(KMSG_DUMP_SHUTDOWN);
 	machine_kexec(kexec_image);
 
 #ifdef CONFIG_KEXEC_JUMP
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


