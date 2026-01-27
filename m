Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DB42E424F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482676; cv=none; b=F4ns6YF9LHEmADbHk0M78YEPg/idZ83mc6O5AS3S8X7wS7fiGYM6USlu7iecSpcSOSj4vEXHTFZaOy+DX7ZuWWHbJagpH513CKWww9+9nyKcRQFcBoHvG8wLDfAP3gNaz4clh7Y1ZrZlbO95kQR1UjnPkkXYoTXjCXO4PxFG7MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482676; c=relaxed/simple;
	bh=rO+r/c+e6vmUpk68oILiibtVwD5Zf9DT3Tro0+y812c=;
	h=Date:To:From:Subject:Message-Id; b=iIvic3/+rQyubEOPiN3of13a68UsRy3nMQAcY1MUv9sLvCEbsM2V/0wwBsIYC5psD+EXXfLbi9dQ0QSBhSPsyNcodRInLwLHXsKVFcUhcokT9lVr3qwvEosIIkH3JrbKIiyGMIYi/zG+0U2Sg96TDye/g/D3cHenSVcu4TMQY7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HH2apGW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HH2apGW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B43C116C6;
	Tue, 27 Jan 2026 02:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482676;
	bh=rO+r/c+e6vmUpk68oILiibtVwD5Zf9DT3Tro0+y812c=;
	h=Date:To:From:Subject:From;
	b=HH2apGW1XPcGzwhH+UtWswUwuhl1qUWomLAaJmkuuwe9gmzs5ZEHXHBEmR2CsdvrN
	 iCqp8GeypWdrw+tWVBYbzWE6K89TO37c/Q1RKW89CJcFli3Ijc1AM67IuJ13m4v0KZ
	 AL/KkPwaHHtNMEiBL4o+Kj6L+OVlcC7laL4595R0=
Date: Mon, 26 Jan 2026 18:57:55 -0800
To: mm-commits@vger.kernel.org,zhiquan1.li@intel.com,xueshuai@linux.alibaba.com,vgoyal@redhat.com,tony.luck@intel.com,osandov@osandov.com,dyoung@redhat.com,bhe@redhat.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] vmcoreinfo-make-hwerr_data-visible-for-debugging.patch removed from -mm tree
Message-Id: <20260127025756.25B43C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmcoreinfo: make hwerr_data visible for debugging
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-make-hwerr_data-visible-for-debugging.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: vmcoreinfo: make hwerr_data visible for debugging
Date: Thu, 22 Jan 2026 02:39:36 -0800

If the kernel is compiled with LTO, hwerr_data symbol might be lost, and
vmcoreinfo doesn't have it dumped.  This is currently seen in some
production kernels with LTO enabled.

Remove the static qualifier from hwerr_data so that the information is
still preserved when the kernel is built with LTO.  Making hwerr_data a
global symbol ensures its debug info survives the LTO link process and
appears in kallsyms.  Also document it, so it doesn't get removed in
the future as suggested by akpm.

Link: https://lkml.kernel.org/r/20260122-fix_vmcoreinfo-v2-1-2d6311f9e36c@debian.org
Fixes: 3fa805c37dd4 ("vmcoreinfo: track and log recoverable hardware errors")
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhiquan Li <zhiquan1.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/vmcore_info.c~vmcoreinfo-make-hwerr_data-visible-for-debugging
+++ a/kernel/vmcore_info.c
@@ -36,7 +36,11 @@ struct hwerr_info {
 	time64_t timestamp;
 };
 
-static struct hwerr_info hwerr_data[HWERR_RECOV_MAX];
+/*
+ * The hwerr_data[] array is declared with global scope so that it remains
+ * accessible to vmcoreinfo even when Link Time Optimization (LTO) is enabled.
+ */
+struct hwerr_info hwerr_data[HWERR_RECOV_MAX];
 
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
 			  void *data, size_t data_len)
_

Patches currently in -mm which might be from leitao@debian.org are


