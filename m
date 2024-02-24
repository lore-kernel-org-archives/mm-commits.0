Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51B479C5
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739402; cv=none; b=GMjL9N5utRatyMsw00EGUrqD7lLBdTN8iaZZAeUUlq9JsHPavRu0tUbaHPIHp57MuIJRnUGEwMpH1FYCGoexNDywk7WCFETOmdXLowYQ1S6xUMN6DoWs6YNINYELaqLfoiFEG+/HF6mxHcSLkdAAiIKobAT/NAVyr1WDiVZsQHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739402; c=relaxed/simple;
	bh=MPm17NhJhVUV17sFte5obpmD09Trn0ZFTSHKZZozx+w=;
	h=Date:To:From:Subject:Message-Id; b=MVQiJFPx1CspCpGM6WSeaQ7h0cSDK3GiMZkvXJCygERdSSwslhakMSAlHl+PRgx2HDjdQ8jo1U2Gq5Ldweh3cmV/VxuhDc+mR4nFg3cbFvkFbY9vLc4CeEgcV8UbnjjsKfJkHRcsaFgq+MCVdzhjdmc0kg9aIT+XYmqMKSBaMkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zXvmCgno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zXvmCgno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB3EC433C7;
	Sat, 24 Feb 2024 01:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739401;
	bh=MPm17NhJhVUV17sFte5obpmD09Trn0ZFTSHKZZozx+w=;
	h=Date:To:From:Subject:From;
	b=zXvmCgnoQjVBE4l359WaGFQz3FWIE2Z1AUyzBXoNWs0b6mGoP1sTb9EIxc7OOLPbE
	 FahVUUN9gwuOjV/Gnm4a/IFEQJcl+rm++vOB8qiK44MN64oUkg0YlU4RjXTuuwHvnq
	 UL56RWO6NBnWsqrfEeidRrTFWqv7YitxawF3FPXY=
Date: Fri, 23 Feb 2024 17:50:01 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch removed from -mm tree
Message-Id: <20240224015001.AEB3EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh, crash: wrap crash dumping code into crash related ifdefs
has been removed from the -mm tree.  Its filename was
     sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: sh, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:50 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on SuperH with some adjustments.

Wrap up crash dumping codes with CONFIG_CRASH_DUMP ifdeffery, and use
IS_ENABLED(CONFIG_CRASH_RESERVE) check to decide if compiling in the
crashkernel reservation code.

Link: https://lkml.kernel.org/r/20240124051254.67105-11-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/machine_kexec.c |    3 +++
 arch/sh/kernel/setup.c         |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sh/kernel/machine_kexec.c~sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/sh/kernel/machine_kexec.c
@@ -153,6 +153,9 @@ void __init reserve_crashkernel(void)
 	unsigned long long crash_size, crash_base;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
+		return;
+
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 			&crash_size, &crash_base, NULL, NULL);
 	if (ret == 0 && crash_size > 0) {
--- a/arch/sh/kernel/setup.c~sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/sh/kernel/setup.c
@@ -220,7 +220,7 @@ void __init __add_active_range(unsigned
 	request_resource(res, &code_resource);
 	request_resource(res, &data_resource);
 	request_resource(res, &bss_resource);
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_CRASH_RESERVE
 	request_resource(res, &crashk_res);
 #endif
 
_

Patches currently in -mm which might be from bhe@redhat.com are


