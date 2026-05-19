Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C5B46AF1E
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208171; cv=none; b=YEPIvVIYJBabCBx+iyX7m+BNlZvpOPJVQA7J0GDZjzN9OrtPsM6CrMN86TrfvmXeulpsb/hTmr8qCbylIbZb7xarX5yzAiTGWQ30PMqVuUx3OHY9fcd9ba2LeV3kCeiR4llDOsiwhHu/jeMr+CFeCc3kMPOIJCMf45eyqM13VLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208171; c=relaxed/simple;
	bh=oDOwra9vuD38GdEUjWBJK/jQenpgD393WwqepssZkxw=;
	h=Date:To:From:Subject:Message-Id; b=I2YqFt2bN08SLlY4tnGAbrThMywMX4zAciUSSvwdwoQWo75X9+SCnj1ly24qHdvQ/7VPNMZkzLY75AEFyf5UxJUUClZXrFIFqd9yjN6dVefwQqpLUeebKYU5WTod131qCMHyLbS6W+jv4CiwWz4vW6XXJa+89jEKMu7d5w6Q5S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oyarNhYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oyarNhYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA76C2BCB3;
	Tue, 19 May 2026 16:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208170;
	bh=oDOwra9vuD38GdEUjWBJK/jQenpgD393WwqepssZkxw=;
	h=Date:To:From:Subject:From;
	b=oyarNhYID4aUgQqokBqSvqQidJgjjR1VUxu+C3X0PrWB+nJ9lB442O8rGYsVxkkjC
	 YdP1tv81WhDXZwLzXp0Ay+0XjUWpWwiwNvZKVC0eWJXo5jQV+5JAEf93Qv9maeFzOK
	 J88c25965JMc8Km7suGvnk8demWUbBCM4dW6Y53g=
Date: Tue, 19 May 2026 09:29:30 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kunit-enable-testing-smp_cond_load_relaxed_timeout.patch removed from -mm tree
Message-Id: <20260519162930.CEA76C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit: enable testing smp_cond_load_relaxed_timeout()
has been removed from the -mm tree.  Its filename was
     kunit-enable-testing-smp_cond_load_relaxed_timeout.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: kunit: enable testing smp_cond_load_relaxed_timeout()
Date: Wed, 8 Apr 2026 17:55:37 +0530

This enables the barrier tests to be built as a module.

Link: https://lore.kernel.org/20260408122538.3610871-14-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Haris Okanovic <harisokn@amazon.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/lib/delay.c               |    2 ++
 drivers/clocksource/arm_arch_timer.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/arm64/lib/delay.c~kunit-enable-testing-smp_cond_load_relaxed_timeout
+++ a/arch/arm64/lib/delay.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/timex.h>
+#include <kunit/visibility.h>
 #include <asm/delay-const.h>
 
 #include <clocksource/arm_arch_timer.h>
@@ -30,6 +31,7 @@ u64 notrace __delay_cycles(void)
 	guard(preempt_notrace)();
 	return __arch_counter_get_cntvct_stable();
 }
+EXPORT_SYMBOL_IF_KUNIT(__delay_cycles);
 
 void __delay(unsigned long cycles)
 {
--- a/drivers/clocksource/arm_arch_timer.c~kunit-enable-testing-smp_cond_load_relaxed_timeout
+++ a/drivers/clocksource/arm_arch_timer.c
@@ -28,6 +28,7 @@
 #include <linux/acpi.h>
 #include <linux/arm-smccc.h>
 #include <linux/ptp_kvm.h>
+#include <kunit/visibility.h>
 
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
@@ -896,6 +897,7 @@ bool arch_timer_evtstrm_available(void)
 	 */
 	return cpumask_test_cpu(raw_smp_processor_id(), &evtstrm_available);
 }
+EXPORT_SYMBOL_IF_KUNIT(arch_timer_evtstrm_available);
 
 static struct arch_timer_kvm_info arch_timer_kvm_info;
 
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

kunit-add-tests-for-smp_cond_load_relaxed_timeout.patch

