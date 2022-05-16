Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413AAC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 16 May 2022 23:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347282AbiEPXgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 May 2022 19:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347272AbiEPXgQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2022 19:36:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF6B6384
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 16:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ECE060F9E
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 23:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883CDC385AA;
        Mon, 16 May 2022 23:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652744174;
        bh=GYWhugp6G8qyMuiuI1rhBoeXrS7SZ8yVXfEBdBN1M8E=;
        h=Date:To:From:Subject:From;
        b=vIGX3lN7QCsHhgSn4m36kTgoZSgTWznWLWgWvrXE61o2haWyJAbilp8gvG4tV8K8K
         iCdwEiCWHmADXEZ4RSimtopD7jgJm8q4SkMLTze3IHEwRgLtbRrAHNO9WxXODuCFsn
         qtEmWqS0cxzO2ANTtkZaL79zZWOko522ks1wZI4E=
Date:   Mon, 16 May 2022 16:36:13 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev,
        varad.gautam@suse.com, shakeelb@google.com,
        mussitantesmortem@gmail.com, manfred@colorfullife.com,
        dbueso@suse.de, chi.minghao@zte.com.cn, arnd@arndb.de,
        crazycdeveloper@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ipc-sem-fix-backward-compatibility-with-x86-32-kernels.patch removed from -mm tree
Message-Id: <20220516233614.883CDC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc, sem: fix backward compatibility with x86-32 kernels
has been removed from the -mm tree.  Its filename was
     ipc-sem-fix-backward-compatibility-with-x86-32-kernels.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Maxim Zhukov <crazycdeveloper@gmail.com>
Subject: ipc, sem: fix backward compatibility with x86-32 kernels
Date: Sun, 15 May 2022 23:01:03 +0300

Since commit 275f22148e87 ("ipc: rename old-style shmctl/semctl/msgctl
syscalls") we have changed behavior:

ksys_semctl lost parse ipc version (ipc_parse_version), because the new
syscall works with IPC_64 only, but the parse function has some side
effect - it removes IPC_64 bit from `cmd`.

Some libc forced sends IPC_64 bit in semctl syscall[1][2][3], this leads
to a bug - X86-32 kernel does not have compat headers and does not
correctly parse received command (cmd) from semctl syscall: cmd have
actual command and IPC_64 bit, thus throw EINVAL error in ksys_semctl

This commit forcibly removes IPC_64 bit from the cmd to restore backward
compatibility.

[1]: https://elixir.bootlin.com/uclibc-ng/v1.0.40/source/libc/misc/sysvipc/sem.c#L58
[2]: https://elixir.bootlin.com/musl/v1.2.3/source/src/ipc/semctl.c#L48 -> https://elixir.bootlin.com/musl/v1.2.3/source/src/ipc/ipc.h#L22
[3]: https://elixir.bootlin.com/glibc/glibc-2.35/source/sysdeps/unix/sysv/linux/semctl.c#L124

Link: https://lkml.kernel.org/r/20220515200103.1408370-2-mussitantesmortem@gmail.com
Signed-off-by: Maxim Zhukov <mussitantesmortem@gmail.com>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Varad Gautam <varad.gautam@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/sem.c~ipc-sem-fix-backward-compatibility-with-x86-32-kernels
+++ a/ipc/sem.c
@@ -1704,7 +1704,7 @@ static long ksys_semctl(int semid, int s
 
 SYSCALL_DEFINE4(semctl, int, semid, int, semnum, int, cmd, unsigned long, arg)
 {
-	return ksys_semctl(semid, semnum, cmd, arg, IPC_64);
+	return ksys_semctl(semid, semnum, cmd & (~IPC_64), arg, IPC_64);
 }
 
 #ifdef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
_

Patches currently in -mm which might be from crazycdeveloper@gmail.com are


