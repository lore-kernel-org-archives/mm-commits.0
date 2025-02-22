Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6059F2AD21;
	Sat, 22 Feb 2025 00:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740182409; cv=none; b=JChO+eA0AibV8ac3BSmZIk6Z5sRWFtVvDYA9QgvLFHcaT7fiEVRZgl/Vj4adox6qVPbyEyjHkTw4LoDWzIHeLdt3b88zLWIdWhDE5t7l7qM8qRyCe0lPe8Ogc+fNUtPxiHOSk28EF2OwiDvEa17hBtrkcV1q/AYM/ljhkNfVPTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740182409; c=relaxed/simple;
	bh=rsO+qylWbsFaZVdLRNNVEsSI+G6f3HMc3CF6cbKwew8=;
	h=Date:To:From:Subject:Message-Id; b=E3AMMp3TQniNWihKrclChwSrZDDmFb502cBJE5I15UUKVnDG+brfKbAUXE5pJTUO2Km9r5MZP9GxfHbNi6QWpjdNycmf1Fn2SyS5NW4lh5Hs1i16JRXGne9XGDx7NNvKtMp/nJNC8hw2HMZ8/h809f5EgdxL6rpvpdOIaJ0t9bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bz3hSf2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bz3hSf2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC1BC4CED6;
	Sat, 22 Feb 2025 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740182408;
	bh=rsO+qylWbsFaZVdLRNNVEsSI+G6f3HMc3CF6cbKwew8=;
	h=Date:To:From:Subject:From;
	b=Bz3hSf2LxXbGg6AIrRn9R/CIgWfU0dbUD+6aMHKUxrocTF7BoC7cq02EfUszxOsuj
	 Otx9NVkpWrJBS+s3ez/6Si2MyKY/0EQ8xNRvKFENma4TIHVVIswiSPduf71voRDjbM
	 0FAlk31LwtAxT+RqiJM+993eZ1xbW4vooY7looZ0=
Date: Fri, 21 Feb 2025 16:00:08 -0800
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,tglx@linutronix.de,takakura@valinux.co.jp,stable@vger.kernel.org,pmladek@suse.com,john.ogness@linutronix.de,jani.nikula@intel.com,haiyangz@microsoft.com,gregkh@linuxfoundation.org,decui@microsoft.com,bhe@redhat.com,hamzamahfooz@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-call-panic-handlers-before-panic_other_cpus_shutdown.patch added to mm-nonmm-unstable branch
Message-Id: <20250222000008.AAC1BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: call panic handlers before panic_other_cpus_shutdown()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-call-panic-handlers-before-panic_other_cpus_shutdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-call-panic-handlers-before-panic_other_cpus_shutdown.patch

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

panic-call-panic-handlers-before-panic_other_cpus_shutdown.patch

