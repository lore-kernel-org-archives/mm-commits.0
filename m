Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523A03EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905010; cv=none; b=bp7zRbvhutUXzSP8uE3l9LnaTF6UsbeDyEbqRm8LgZtkUkcB8MuO9SVPZCv648vikrCqZlI7YjaP/UyPoynxPABumIiaDbCcsHVjGUmBvkV/F7aC80+XYXxjxlZRlLrWOB12wBNFCyoSmyjATk6uqXvj16j1CK6CtHHJTqo/bF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905010; c=relaxed/simple;
	bh=m+QIiTKoCEYzU3DNPcLWV08c8aK331P+iu6094Fvhfk=;
	h=Date:To:From:Subject:Message-Id; b=oYlO1xMcerjhLz3gNxqjJEBpOq/YbZsxrh16fOuBSBKEPnGy1hbnxYiPV6DpkFW4UOU4J87uNgNIte0DSbOCB1F0CudIw0EXeB7WX7GLXXVCZwVWDNWlq+C49cYjap4x+qqCvJdmhG3rmQhr29GcNTwP40UyNmlyc7PvkzPwFGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AVnEDDaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AVnEDDaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A331C4CEF1;
	Sun,  1 Feb 2026 00:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905010;
	bh=m+QIiTKoCEYzU3DNPcLWV08c8aK331P+iu6094Fvhfk=;
	h=Date:To:From:Subject:From;
	b=AVnEDDaTobgMPfZTZy87IjMbKjs1fPgdJK3vwztgpDWc2GQ+ifTCtAFEx0HJCAMh3
	 OydbW9gxJ5wFWEOegZVo74NWkdDbJcDug0VFQSRLbpFfTyAmgOTFVKG4X7q3SADsAc
	 huOAV5zsLJgvKzzsuCwPbxH/+iAgJRgolriU/Uj0=
Date: Sat, 31 Jan 2026 16:16:49 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernelh-move-verify_octal_permissions-to-sysfsh.patch removed from -mm tree
Message-Id: <20260201001650.2A331C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel.h: move VERIFY_OCTAL_PERMISSIONS() to sysfs.h
has been removed from the -mm tree.  Its filename was
     kernelh-move-verify_octal_permissions-to-sysfsh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: kernel.h: move VERIFY_OCTAL_PERMISSIONS() to sysfs.h
Date: Thu, 15 Jan 2026 23:25:06 -0500

The macro is related to sysfs, but is defined in kernel.h.  Move it to the
proper header, and unload the generic kernel.h.

Now that the macro is removed from kernel.h, linux/moduleparam.h is
decoupled, and kernel.h inclusion can be removed.

Link: https://lkml.kernel.org/r/20260116042510.241009-4-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/sysfs.rst |    2 +-
 include/linux/kernel.h              |   12 ------------
 include/linux/moduleparam.h         |    2 +-
 include/linux/sysfs.h               |   13 +++++++++++++
 4 files changed, 15 insertions(+), 14 deletions(-)

--- a/Documentation/filesystems/sysfs.rst~kernelh-move-verify_octal_permissions-to-sysfsh
+++ a/Documentation/filesystems/sysfs.rst
@@ -120,7 +120,7 @@ is equivalent to doing::
 	    .store = store_foo,
     };
 
-Note as stated in include/linux/kernel.h "OTHER_WRITABLE?  Generally
+Note as stated in include/linux/sysfs.h "OTHER_WRITABLE?  Generally
 considered a bad idea." so trying to set a sysfs file writable for
 everyone will fail reverting to RO mode for "Others".
 
--- a/include/linux/kernel.h~kernelh-move-verify_octal_permissions-to-sysfsh
+++ a/include/linux/kernel.h
@@ -388,16 +388,4 @@ static inline void ftrace_dump(enum ftra
 # define REBUILD_DUE_TO_DYNAMIC_FTRACE
 #endif
 
-/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
-#define VERIFY_OCTAL_PERMISSIONS(perms)						\
-	(BUILD_BUG_ON_ZERO((perms) < 0) +					\
-	 BUILD_BUG_ON_ZERO((perms) > 0777) +					\
-	 /* USER_READABLE >= GROUP_READABLE >= OTHER_READABLE */		\
-	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 4) < (((perms) >> 3) & 4)) +	\
-	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 4) < ((perms) & 4)) +		\
-	 /* USER_WRITABLE >= GROUP_WRITABLE */					\
-	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 2) < (((perms) >> 3) & 2)) +	\
-	 /* OTHER_WRITABLE?  Generally considered a bad idea. */		\
-	 BUILD_BUG_ON_ZERO((perms) & 2) +					\
-	 (perms))
 #endif
--- a/include/linux/moduleparam.h~kernelh-move-verify_octal_permissions-to-sysfsh
+++ a/include/linux/moduleparam.h
@@ -8,7 +8,7 @@
 #include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/stringify.h>
-#include <linux/kernel.h>
+#include <linux/sysfs.h>
 #include <linux/types.h>
 
 /*
--- a/include/linux/sysfs.h~kernelh-move-verify_octal_permissions-to-sysfsh
+++ a/include/linux/sysfs.h
@@ -808,4 +808,17 @@ static inline void sysfs_put(struct kern
 	kernfs_put(kn);
 }
 
+/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
+#define VERIFY_OCTAL_PERMISSIONS(perms)						\
+	(BUILD_BUG_ON_ZERO((perms) < 0) +					\
+	 BUILD_BUG_ON_ZERO((perms) > 0777) +					\
+	 /* USER_READABLE >= GROUP_READABLE >= OTHER_READABLE */		\
+	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 4) < (((perms) >> 3) & 4)) +	\
+	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 4) < ((perms) & 4)) +		\
+	 /* USER_WRITABLE >= GROUP_WRITABLE */					\
+	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 2) < (((perms) >> 3) & 2)) +	\
+	 /* OTHER_WRITABLE?  Generally considered a bad idea. */		\
+	 BUILD_BUG_ON_ZERO((perms) & 2) +					\
+	 (perms))
+
 #endif /* _SYSFS_H_ */
_

Patches currently in -mm which might be from ynorov@nvidia.com are


