Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B7DC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 19:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbiDXTkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 15:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238900AbiDXTkY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 15:40:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCC03CFDB
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 12:37:18 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 728951EC01E0;
        Sun, 24 Apr 2022 21:37:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650829032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fL82ZKQc3hrQtDRzDMEXgqYgRbV7q9sKsKHgTS/BWb4=;
        b=rmZlYipIsNkTCIzEPZmdYebyhkh1f0Z4iAtavKM5tXYAkFUnLRI8NAMiCjCDLVJPgnlk0A
        l/2t3rE9If18WB7NByS8W8hlucCvIVr+S5Xmm+f5DhNzM2BtbAJFu5YVw3ZM85VLJvsWfW
        bN877xHSWxzav+agmUKtMYCGjqZ0aPs=
Date:   Sun, 24 Apr 2022 21:37:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <YmWm5AXdwgwu57KZ@zn.tnic>
References: <YlxtTNFP58TcUHZQ@zn.tnic>
 <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic>
 <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic>
 <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic>
 <YmFy8DEqvX4FlnuB@zn.tnic>
 <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Apr 21, 2022 at 10:22:32AM -0700, Linus Torvalds wrote:
> I think 'copy_{to,from}_user()' actually does go to the effort to try
> to do byte-exact results, though.

Yeah, we have had headaches with this byte-exact copying, wrt MCEs.

> In particular, see copy_user_handle_tail in arch/x86/lib/copy_user_64.S.
> 
> But I think that we long ago ended up deciding it really wasn't worth
> doing it, and x86 ends up just going to unnecessary lengths for this
> case.

You could give me some more details but AFAIU, you mean, that
fallback to byte-sized reads is unnecessary and I can get rid of
copy_user_handle_tail? Because that would be a nice cleanup.

Anyway, I ran your short prog and it all looks like you predicted it:

fsrm:
----
openat(AT_FDCWD, "/dev/zero", O_RDONLY) = 3
mmap(NULL, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fafd78fe000
munmap(0x7fafd790e000, 65536)           = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 17
exit_group(17)                          = ?
+++ exited with 17 +++

erms:
-----
openat(AT_FDCWD, "/dev/zero", O_RDONLY) = 3
mmap(NULL, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe0b5321000
munmap(0x7fe0b5331000, 65536)           = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 17
exit_group(17)                          = ?
+++ exited with 17 +++

rep_good:
---------
openat(AT_FDCWD, "/dev/zero", O_RDONLY) = 3
mmap(NULL, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0b5f0c7000
munmap(0x7f0b5f0d7000, 65536)           = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 16
exit_group(16)                          = ?
+++ exited with 16 +++

original:
---------
openat(AT_FDCWD, "/dev/zero", O_RDONLY) = 3
mmap(NULL, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3ff61c6000
munmap(0x7f3ff61d6000, 65536)           = 0
read(3, strace: umoven: short read (17 < 33) @0x7f3ff61d5fef
0x7f3ff61d5fef, 65536)          = 3586
exit_group(3586)                        = ?
+++ exited with 2 +++

that "umoven: short read" is strace spitting out something about the
address space of the tracee being unaccessible. But the 17 bytes short
read is still there.

From strace sources:

/* legacy method of copying from tracee */
static int
umoven_peekdata(const int pid, kernel_ulong_t addr, unsigned int len,
		void *laddr)
{

	...

	switch (errno) {
			case EFAULT: case EIO: case EPERM:
				/* address space is inaccessible */
				if (nread) {
					perror_msg("umoven: short read (%u < %u) @0x%" PRI_klx,
						   nread, nread + len, addr - nread);
				}
				return -1;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
