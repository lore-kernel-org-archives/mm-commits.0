Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DE6CA5A;
	Sat, 22 Feb 2025 03:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740196240; cv=none; b=gVlwGpYtn5DLHPCZwanVDuSn3JPcLsQ5cWxkntyoRcSxgaBUIUVh0aYNRjB8xL9B11tHx47SOsyXHgr3NIXlc7Dq6sVf1i+EGDGCZxFSMQ1JsBII8Fp/G7I2VUsTO6DD8qpF++15kC5i8QlC7iVKEqumiR4n+Wf28m9h1U+KUkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740196240; c=relaxed/simple;
	bh=c1TegWbfkRTGCQgQmIA6NFMq1GNOSVLr8GfKLgX66GU=;
	h=Date:To:From:Subject:Message-Id; b=D7b3xpE9jchvDiyhBOhKLlwdh8qDBp0s64Fn/jlAxVBaZmKic0BLpvxTxWgOkNvsRoz4EkbrBvphzWWoE/KdIEXcA5g4nvGlWa9Gwwu3MoVbjHkyA3EaDQxoI5/aG9uE7uMMbJC9cRRaPGSiLsMlMlhi3/X0X8fFciPVURl1eEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1wCZKK71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1wCZKK71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F95CC4CED1;
	Sat, 22 Feb 2025 03:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740196239;
	bh=c1TegWbfkRTGCQgQmIA6NFMq1GNOSVLr8GfKLgX66GU=;
	h=Date:To:From:Subject:From;
	b=1wCZKK71igKF5Vk25ueqMgUaJUAgeBvDYRjHOTrMQ/I10muOugpmVnJAVjgrlJKI7
	 eWzZbnJ9fzyLlMDQztL8pXK18njz2W1BAh/1dOOqb9Smmqjv8FGul100grdfNkUd26
	 KhmhbbehmEWA2aLNPteSXpxTbE4+jVSEKdrnlNxU=
Date: Fri, 21 Feb 2025 19:50:39 -0800
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,tglx@linutronix.de,takakura@valinux.co.jp,stable@vger.kernel.org,pmladek@suse.com,john.ogness@linutronix.de,jani.nikula@intel.com,haiyangz@microsoft.com,gregkh@linuxfoundation.org,decui@microsoft.com,bhe@redhat.com,hamzamahfooz@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] panic-call-panic-handlers-before-panic_other_cpus_shutdown.patch removed from -mm tree
Message-Id: <20250222035039.9F95CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: call panic handlers before panic_other_cpus_shutdown()
has been removed from the -mm tree.  Its filename was
     panic-call-panic-handlers-before-panic_other_cpus_shutdown.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: panic: call panic handlers before panic_other_cpus_shutdown()
Date: Fri, 21 Feb 2025 16:30:52 -0500

Since the panic handlers may require certain cpus to be online to panic
gracefully, we should call them before turning off SMP.  Without this
re-ordering, on Hyper-V hv_panic_vmbus_unload() times out, because the
vmbus channel is bound to VMBUS_CONNECT_CPU and unless the crashing cpu is
the same as VMBUS_CONNECT_CPU, VMBUS_CONNECT_CPU will be offlined by
crash_smp_send_stop() before the vmbus channel can be deconstructed.

Link: https://lkml.kernel.org/r/20250221213055.133849-1-hamzamahfooz@linux.microsoft.com
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Baoquan he <bhe@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Ryo Takakura <takakura@valinux.co.jp>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/panic.c~panic-call-panic-handlers-before-panic_other_cpus_shutdown
+++ a/kernel/panic.c
@@ -372,16 +372,16 @@ void panic(const char *fmt, ...)
 	if (!_crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
-	panic_other_cpus_shutdown(_crash_kexec_post_notifiers);
-
-	printk_legacy_allow_panic_sync();
-
 	/*
 	 * Run any panic handlers, including those that might need to
 	 * add information to the kmsg dump output.
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
+	panic_other_cpus_shutdown(_crash_kexec_post_notifiers);
+
+	printk_legacy_allow_panic_sync();
+
 	panic_print_sys_info(false);
 
 	kmsg_dump_desc(KMSG_DUMP_PANIC, buf);
_

Patches currently in -mm which might be from hamzamahfooz@linux.microsoft.com are


