Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E438C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 16 May 2022 21:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349108AbiEPVNL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 May 2022 17:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349428AbiEPVM4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2022 17:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959872729
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 14:06:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49FB7B81643
        for <mm-commits@vger.kernel.org>; Mon, 16 May 2022 21:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5886C385AA;
        Mon, 16 May 2022 21:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652735185;
        bh=pI6l3afKb3BCWiQR71Rp1zB8qcEaxtPJExfdoz/0o2s=;
        h=Date:To:From:Subject:From;
        b=k5mfT9X73eQbE5itQA+9GHZEOPwtqHsNpcKKzHtP2r7vimLTpf+LNKCvjuEut7Hgn
         avun3+y9k1Y60UJm5D2W2gbl+bLyeLk+l4J+lqkDCId/i0YrKL6kyzuyb0oLQF5lnO
         QEzw9ZupIvStyx+eRIfCK/IAe8FKPe2WVB9crad0=
Date:   Mon, 16 May 2022 14:06:24 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev,
        varad.gautam@suse.com, shakeelb@google.com,
        mussitantesmortem@gmail.com, manfred@colorfullife.com,
        dbueso@suse.de, chi.minghao@zte.com.cn, arnd@arndb.de,
        crazycdeveloper@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-sem-fix-backward-compatibility-with-x86-32-kernels.patch added to mm-nonmm-unstable branch
Message-Id: <20220516210624.E5886C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc, sem: fix backward compatibility with x86-32 kernels
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-sem-fix-backward-compatibility-with-x86-32-kernels.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-sem-fix-backward-compatibility-with-x86-32-kernels.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ipc-sem-fix-backward-compatibility-with-x86-32-kernels.patch

