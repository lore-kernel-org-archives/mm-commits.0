Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DFFE7734C
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjI3AVT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjI3AVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E881BF;
        Fri, 29 Sep 2023 17:21:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618E6C433CA;
        Sat, 30 Sep 2023 00:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033272;
        bh=TcrDacEPisU942e9RSHrZ3LKTons19KIidG5A7i52b0=;
        h=Date:To:From:Subject:From;
        b=axi39thPiXzItBOkz/1FFWHeLTt10Hj2jpPQ8RwYcdDfXR3+9/0j/qTRA5lAScF8l
         kZo+cp/IITdxsKj09VZmoSZy+PPD7PQvNJnK8sdc1S+Fwu/FFrhKuKEvGCj0gg87N0
         Vn6tYAe3wqK1CBSN2nNku+Fqyz3JBdMyZXz5w+Aw=
Date:   Fri, 29 Sep 2023 17:21:11 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, keescook@chromium.org,
        ebiederm@xmission.com, brauner@kernel.org, gerg@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-binfmt_elf_efpic-fix-personality-for-elf-fdpic.patch removed from -mm tree
Message-Id: <20230930002112.618E6C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: binfmt_elf_efpic: fix personality for ELF-FDPIC
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf_efpic-fix-personality-for-elf-fdpic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Greg Ungerer <gerg@kernel.org>
Subject: fs: binfmt_elf_efpic: fix personality for ELF-FDPIC
Date: Thu, 7 Sep 2023 11:18:08 +1000

The elf-fdpic loader hard sets the process personality to either
PER_LINUX_FDPIC for true elf-fdpic binaries or to PER_LINUX for normal ELF
binaries (in this case they would be constant displacement compiled with
-pie for example).  The problem with that is that it will lose any other
bits that may be in the ELF header personality (such as the "bug
emulation" bits).

On the ARM architecture the ADDR_LIMIT_32BIT flag is used to signify a
normal 32bit binary - as opposed to a legacy 26bit address binary.  This
matters since start_thread() will set the ARM CPSR register as required
based on this flag.  If the elf-fdpic loader loses this bit the process
will be mis-configured and crash out pretty quickly.

Modify elf-fdpic loader personality setting so that it preserves the upper
three bytes by using the SET_PERSONALITY macro to set it.  This macro in
the generic case sets PER_LINUX and preserves the upper bytes. 
Architectures can override this for their specific use case, and ARM does
exactly this.

The problem shows up quite easily running under qemu using the ARM
architecture, but not necessarily on all types of real ARM hardware.  If
the underlying ARM processor does not support the legacy 26-bit addressing
mode then everything will work as expected.

Link: https://lkml.kernel.org/r/20230907011808.2985083-1-gerg@kernel.org
Fixes: 1bde925d23547 ("fs/binfmt_elf_fdpic.c: provide NOMMU loader for regular ELF binaries")
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg Ungerer <gerg@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/binfmt_elf_fdpic.c~fs-binfmt_elf_efpic-fix-personality-for-elf-fdpic
+++ a/fs/binfmt_elf_fdpic.c
@@ -345,10 +345,9 @@ static int load_elf_fdpic_binary(struct
 	/* there's now no turning back... the old userspace image is dead,
 	 * defunct, deceased, etc.
 	 */
+	SET_PERSONALITY(exec_params.hdr);
 	if (elf_check_fdpic(&exec_params.hdr))
-		set_personality(PER_LINUX_FDPIC);
-	else
-		set_personality(PER_LINUX);
+		current->personality |= PER_LINUX_FDPIC;
 	if (elf_read_implies_exec(&exec_params.hdr, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
 
_

Patches currently in -mm which might be from gerg@kernel.org are


