Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E62869959
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248800; cv=none; b=n2l264AdhxPiQYiV0gnCv0HLr317QlU575wvOhNGsocTDzSgqb88phlczOTogPOcd7LhgkVIt00VXYae3m8C6H0613U3DmQjHbRv3xYRCt2gCpTEQ82OYvU7Mr9tXWxtBQ0isQodQIVjD+R34Pi19tN/IWAZQpf2foQhbgEhDrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248800; c=relaxed/simple;
	bh=gZ0JIPPU6a4gmWzet1U4TfGTV36qycIx5jtnbwiOgqU=;
	h=Date:To:From:Subject:Message-Id; b=b3npUZ+OV01T6BuvZVcQiLH9ImEglQZu+SzyjMXyapsMvWNYgE+ee9oDYAxH0tCdA+VWe3LhbKvlqfiUT4RCUYZ7dfj44RHyn+dPUOC0JMi3h92z5IpDGRylYos0QN0k4Iy9r/LxA+/58PLGlcixpbDSHDz21HqQO3adNrrUn5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YC7puIfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YC7puIfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F998C4CEC2;
	Mon,  2 Sep 2024 03:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248800;
	bh=gZ0JIPPU6a4gmWzet1U4TfGTV36qycIx5jtnbwiOgqU=;
	h=Date:To:From:Subject:From;
	b=YC7puIfEMVPgCMqrKyOPU30vZqXRKy4CF/4VfSQoDYgW5pVz03IQgXOpuprtlBSRc
	 wbvF9uSE463mRIDBqbJRZoX3/cqAEzoEf99fR0k4BRTb1V5foyG7ssGyMgx7ccJ6Id
	 4CownQVDOZonUGXg96rT8LuMdxXjOkb4UDVSxGKM=
Date: Sun, 01 Sep 2024 20:46:39 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,viresh.kumar@linaro.org,tglx@linutronix.de,rostedt@goodmis.org,rafael@kernel.org,ppaalanen@gmail.com,peterz@infradead.org,npiggin@gmail.com,nouveau@lists.freedesktop.org,naveen@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mcoquelin.stm32@gmail.com,luto@kernel.org,longman@redhat.com,linux@armlinux.org.uk,karolherbst@gmail.com,joel@jms.id.au,jk@ozlabs.org,hpa@zytor.com,gregkh@linuxfoundation.org,eajames@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,andrew@codeconstruct.com.au,alistair@popple.id.au,alexandre.torgue@foss.st.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] locking-ww_mutex-test-add-module_description.patch removed from -mm tree
Message-Id: <20240902034640.1F998C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: locking/ww_mutex/test: add MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     locking-ww_mutex-test-add-module_description.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: locking/ww_mutex/test: add MODULE_DESCRIPTION()
Date: Tue, 30 Jul 2024 07:43:22 -0700

Fix the 'make W=1' warning:
WARNING: modpost: missing MODULE_DESCRIPTION() in kernel/locking/test-ww_mutex.o

Link: https://lkml.kernel.org/r/20240730-module_description_orphans-v1-5-7094088076c8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Alistar Popple <alistair@popple.id.au>
Cc: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eddie James <eajames@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Karol Herbst <karolherbst@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nouveau <nouveau@lists.freedesktop.org>
Cc: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/test-ww_mutex.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/locking/test-ww_mutex.c~locking-ww_mutex-test-add-module_description
+++ a/kernel/locking/test-ww_mutex.c
@@ -697,3 +697,4 @@ module_exit(test_ww_mutex_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("API test facility for ww_mutexes");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are


