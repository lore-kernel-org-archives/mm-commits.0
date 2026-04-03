Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7006A34D91F
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198557; cv=none; b=irwG2EMvrjQ/XfIGT437bmG5HeMXJS4ZhCOnczPK7mDGae0CXMuRplgHHkFOdKG73XaoHZn+/XONnGPNNOTIL2mNNki7W85LAgA40MKKswOnDfjT17pkek3uA8elOxVojI3k+a9cEgUfjyYULW864zoI+CYfjuTL8Twt4vKuii0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198557; c=relaxed/simple;
	bh=FM824zmGQ7gQ/yIjSprpmrUwoG1TzwBr5dU58oS/6gE=;
	h=Date:To:From:Subject:Message-Id; b=L38BFuWrRmHvqcmNz+QNSu6KeuYMZBYn/HOJIdXlcU1rIpooivqz/XCYRK5gz3uAsey5w2qT3yydvHqO0O5F0ozcWZcN9iaVqLDubyWwBCk4pmXt1qF/GA2u4xVJgKnk84gvhp39TU6tZ/3v1RCKRkePQ2xrUeSPtI4hd+O9PR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=or0k6Hq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="or0k6Hq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486EEC4CEF7;
	Fri,  3 Apr 2026 06:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198557;
	bh=FM824zmGQ7gQ/yIjSprpmrUwoG1TzwBr5dU58oS/6gE=;
	h=Date:To:From:Subject:From;
	b=or0k6Hq2qMNStpodoNfXqBD35YfFngB95uL9ngds3CA4nL+fL53dGOFBOFVHFyAT0
	 YcwzmQeWHX5MsYnwpUnQh/WYI5OsaO7QEl1eCuxEuGI3P8wobdwo90bAnVJSgkWQN4
	 Q9s/a1Vbs79y+3cuLgc0AJsIbW/JLzaarzPwiJ6E=
Date: Thu, 02 Apr 2026 23:42:36 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tstaudt@de.ibm.com,sourabhjain@linux.ibm.com,ryncsn@gmail.com,robh@kernel.org,lkp@intel.com,krzk@kernel.org,kernelfans@gmail.com,dyoung@redhat.com,chleroy@kernel.org,bhe@redhat.com,arnaud.lefebvre@clever-cloud.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt.patch removed from -mm tree
Message-Id: <20260403064237.486EEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: align the declaration of crash_load_dm_crypt_keys with CONFIG_CRASH_DM_CRYPT
has been removed from the -mm tree.  Its filename was
     crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Coiby Xu <coxu@redhat.com>
Subject: crash: align the declaration of crash_load_dm_crypt_keys with CONFIG_CRASH_DM_CRYPT
Date: Wed, 25 Feb 2026 14:03:45 +0800

This will prevent a compilation failure when CONFIG_CRASH_DUMP is enabled
but CONFIG_CRASH_DM_CRYPT is disabled,

       arch/powerpc/kexec/elf_64.c: In function 'elf64_load':
    >> arch/powerpc/kexec/elf_64.c:82:23: error: implicit declaration of function 'crash_load_dm_crypt_keys' [-Werror=implicit-function-declaration]
          82 |                 ret = crash_load_dm_crypt_keys(image);
             |                       ^~~~~~~~~~~~~~~~~~~~~~~~
       cc1: some warnings being treated as errors

Link: https://lkml.kernel.org/r/20260225060347.718905-3-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602120648.RgQALnnI-lkp@intel.com/
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Staudt <tstaudt@de.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/crash_core.h~crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt
+++ a/include/linux/crash_core.h
@@ -34,13 +34,6 @@ static inline void arch_kexec_protect_cr
 static inline void arch_kexec_unprotect_crashkres(void) { }
 #endif
 
-#ifdef CONFIG_CRASH_DM_CRYPT
-int crash_load_dm_crypt_keys(struct kimage *image);
-ssize_t dm_crypt_keys_read(char *buf, size_t count, u64 *ppos);
-#else
-static inline int crash_load_dm_crypt_keys(struct kimage *image) {return 0; }
-#endif
-
 #ifndef arch_crash_handle_hotplug_event
 static inline void arch_crash_handle_hotplug_event(struct kimage *image, void *arg) { }
 #endif
@@ -96,4 +89,11 @@ static inline void crash_save_cpu(struct
 static inline int kimage_crash_copy_vmcoreinfo(struct kimage *image) { return 0; };
 #endif /* CONFIG_CRASH_DUMP*/
 
+#ifdef CONFIG_CRASH_DM_CRYPT
+int crash_load_dm_crypt_keys(struct kimage *image);
+ssize_t dm_crypt_keys_read(char *buf, size_t count, u64 *ppos);
+#else
+static inline int crash_load_dm_crypt_keys(struct kimage *image) {return 0; }
+#endif
+
 #endif /* LINUX_CRASH_CORE_H */
_

Patches currently in -mm which might be from coxu@redhat.com are


