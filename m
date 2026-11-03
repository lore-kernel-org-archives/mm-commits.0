Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675974;
	b=AGnebpMya4MAT/w5Gd5wexamrIwAHit1VPxybbl54CHUTp94HligqREbh2OerVnK2+pQ
	 d0neKJUE1Ve9KQNvKmwm1t1INfJ8gNkkLuGwce0uqef0k5/mgHUPdRu1qTZtj/KNqd3hl
	 uDzWp8x8CTatoNSaub1vqaVizwnlRlT2SwktB4ptQjGXaemqySBeKU8FVURwhTTRb13BX
	 62YRT7KunddYihk0ed+KHhGIewTDamsVDAp67H8j2zQ49ugbnfR+WUmJ1q3iXL4ZvkMsD
	 hZp4dC7E2qUa7iVflDQmVlkEwBOnNgRjbK4Ra88VLVy3gRbhjWruB1wcSqbWBrEgV6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675974;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fjv4LA4N4Xe4HPcCC9RP+cj5V9bAA53JuZ4wXmrePi0=;
	b=s3481wxuAdZS91eT9sGlilhQZpZ5lo/iPGAk6qbwtIyNJbKqgXnUs7a9m66Z8crxNZt4
	 y03yVTzJj9hI4MhZhZMSH6+KfbuIGyk2rq8uxS0LlSYV6Rq1hde/kWuFBSPQQSP1HGDUT
	 SOjA8dQAqN3qAdB8mkqMYZ1JY6x4XUsme5vY6AxyCUtEoRVmP7quBW9K5jxKOkoPM/IFy
	 ZySZO9AZVOfUbYgfrEYQoojuXXZHAstSdaXxuZaCK8umbjHRAE8/KPFHAUg9D5JuOmwZ8
	 MvWcH1iVN3iWv1Ah4Lf9mDRqGoFN1Pt5GbiEDRC3pdn7TXRVb+nJhjahM9v35G2OpZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CVCmJqX8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46447606A32D;
	Tue,  3 Nov 2026 03:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CVCmJqX8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82751F0093A;
	Tue,  3 Nov 2026 03:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675973;
	bh=fjv4LA4N4Xe4HPcCC9RP+cj5V9bAA53JuZ4wXmrePi0=;
	h=Date:To:From:Subject;
	b=CVCmJqX8ggjS8p647qDartPNMqnlEXnbdOV3WTp5yrowiN6DiPv7Bk5dg/HtXxwRm
	 npGJ0WlFlXEjEdhOmPYpfk7zUD3TC19hy8HZYG9qSg+fNBxedwX5CR/W6F4auosRg0
	 AXgecXWeF/p0JR8Z9zxKbQBKmJGb0SYRubOis0Go=
Date: Mon, 02 Nov 2026 19:19:33 -0800
To: mm-commits@vger.kernel.org,stefan.kristiansson@saunalahti.fi,
	stable@vger.kernel.org,shorne@gmail.com,lkp@intel.com,kmehltretter@gmail.com,
	jonas@southpole.se,brads@mainlining.org,arnd@arndb.de,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] openrisc-export-mulsi3.patch removed from -mm tree
Message-Id: <20261103031933.B82751F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: openrisc: export __mulsi3 for modules
has been removed from the -mm tree.  Its filename was
     openrisc-export-mulsi3.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: openrisc: export __mulsi3 for modules
Date: Wed Oct 28 06:24:22 PM PDT 2026

OpenRISC configurations without hardware multiplication fail to build
modules which contain compiler-generated calls to __mulsi3.  The failure
is widespread, affecting filesystems, drivers and KUnit tests at modpost.

When CONFIG_OPENRISC_HAVE_INST_MUL is disabled, the architecture Makefile
passes -msoft-mul to GCC.  The multiplication helper is supplied by the
libgcc archive linked into vmlinux, but or32_ksyms.c does not export it. 
Built-in callers can therefore link while module callers cannot resolve
the symbol.

Export __mulsi3 alongside the other compiler-generated helpers.

The omission predates 7c3f4d699f34 ("resource, kunit: stop selecting
GET_FREE_REGION"), which the robot identified when reporting an additional
failing module.  It was already present in the initial OpenRISC export
list.

Fixes: 616257669e1a ("OpenRISC: Miscellaneous")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: <stable@vger.kernel.org>
---

 arch/openrisc/kernel/or32_ksyms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/openrisc/kernel/or32_ksyms.c~openrisc-export-mulsi3
+++ a/arch/openrisc/kernel/or32_ksyms.c
@@ -35,6 +35,7 @@ DECLARE_EXPORT(__divsi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__modsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ashrdi3);
 DECLARE_EXPORT(__ashldi3);
 DECLARE_EXPORT(__lshrdi3);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

