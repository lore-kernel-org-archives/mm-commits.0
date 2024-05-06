Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F62CA5;
	Mon,  6 May 2024 01:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958095; cv=none; b=Q012YZtFDdIiGXnNnnU+jteDY8UkB/SmVpz4hHpk7dx2pN9kad1I0wr0GhIHlaM4hSI/6i6iqMoe8s/X0PmQpeA/Yzjl9m/+LLwwEKOGfdjgXt58yNAVjp7dlMYBY10lXLv9ca8+SxJf8m0AT/l7x0LRFQ7X9xx01Y38E432W10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958095; c=relaxed/simple;
	bh=hrFo2LOyBsijv7e3nEQWQVsF47QlhCdscr053TO/d8w=;
	h=Date:To:From:Subject:Message-Id; b=Zm8KHMSQyPQSCcs2QMm65BjsMjNNa1Txl9gwKd1xzR2lMyOJB0Q/tPZdF5AZNc1juWSalR2hJTgn59jBOzkSGTW/8xM/CXU9rzD2gbFyGt+/tKHQy7f/ASbPHwG45xrYt2NtZjHg6nW2zi2aW10ks/d7ziM+p2nnW1v/Qv4WrAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VRal3Rhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VRal3Rhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8C5C113CC;
	Mon,  6 May 2024 01:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958094;
	bh=hrFo2LOyBsijv7e3nEQWQVsF47QlhCdscr053TO/d8w=;
	h=Date:To:From:Subject:From;
	b=VRal3RhvRevoEXMXgHmqktYZmXPTcWQ8RwysI6azhzqpls7BJ3YSSfYUaiQKLr6ic
	 VTuqdL4Cepej3FpyxlX69co9VtSWeDzheC8U9EpOBLsLHLaF8ocgofEzNCDnkSadoO
	 1DGqhL7EY0t/PMJGbtqHnHsAZIxYLmYOkPtF/8gY=
Date: Sun, 05 May 2024 18:14:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jirislaby@kernel.org,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-fix-the-unexpected-kexec_dprintk-macro.patch removed from -mm tree
Message-Id: <20240506011454.BA8C5C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: fix the unexpected kexec_dprintk() macro
has been removed from the -mm tree.  Its filename was
     kexec-fix-the-unexpected-kexec_dprintk-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: fix the unexpected kexec_dprintk() macro
Date: Tue, 9 Apr 2024 12:22:38 +0800

Jiri reported that the current kexec_dprintk() always prints out debugging
message whenever kexec/kdmmp loading is triggered.  That is not wanted. 
The debugging message is supposed to be printed out when 'kexec -s -d' is
specified for kexec/kdump loading.

After investigating, the reason is the current kexec_dprintk() takes
printk(KERN_INFO) or printk(KERN_DEBUG) depending on whether '-d' is
specified.  However, distros usually have defaulg log level like below:

 [~]# cat /proc/sys/kernel/printk
 7       4      1       7

So, even though '-d' is not specified, printk(KERN_DEBUG) also always
prints out.  I thought printk(KERN_DEBUG) is equal to pr_debug(), it's
not.

Fix it by changing to use pr_info() instead which are expected to work.

Link: https://lkml.kernel.org/r/20240409042238.1240462-1-bhe@redhat.com
Fixes: cbc2fe9d9cb2 ("kexec_file: add kexec_file flag to control debug printing")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/4c775fca-5def-4a2d-8437-7130b02722a2@kernel.org
Reviewed-by: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/kexec.h~kexec-fix-the-unexpected-kexec_dprintk-macro
+++ a/include/linux/kexec.h
@@ -461,10 +461,8 @@ static inline void arch_kexec_pre_free_p
 
 extern bool kexec_file_dbg_print;
 
-#define kexec_dprintk(fmt, ...)					\
-	printk("%s" fmt,					\
-	       kexec_file_dbg_print ? KERN_INFO : KERN_DEBUG,	\
-	       ##__VA_ARGS__)
+#define kexec_dprintk(fmt, arg...) \
+        do { if (kexec_file_dbg_print) pr_info(fmt, ##arg); } while (0)
 
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
_

Patches currently in -mm which might be from bhe@redhat.com are


