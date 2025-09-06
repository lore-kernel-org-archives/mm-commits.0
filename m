Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C4817A310
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 01:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757123086; cv=none; b=CwMp1dnJdDkedOk4bAQ2Jt2iqU2hEsx2PM4jpRMu+NjUA3fOxSPJxNoG+/lZZJgBehf7uxhH6a2S92Pq+u4DjIGDILvGSMqi2XsykAKHqw15WpO9bAg3tFkUsCNWMbLoMSwE9H/Kespefpk2ljo1/6u3rE40uD/0p7QPQXaOhQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757123086; c=relaxed/simple;
	bh=n6GqUMeJ7l8/s43NVD8q/AmPkLO2J/MHKg1Q6723vYs=;
	h=Date:To:From:Subject:Message-Id; b=QqoG+mcIT/QF8pb405aA+3gA2hQu1nVey4YXBty6NIDhozKAT0dZMYagLF40zDzh5MTdXRQIh/47uEi3/BZS26/VMlt2KsGuG7FRPvf2e6VET2aTg9ggZgS0IMV/Rr69Fu+nzqwbo1h3TBc4cU4sVfioSKIKR9+6MIrq2Ktj2Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMaAqrwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMaAqrwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174E6C4CEF1;
	Sat,  6 Sep 2025 01:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757123086;
	bh=n6GqUMeJ7l8/s43NVD8q/AmPkLO2J/MHKg1Q6723vYs=;
	h=Date:To:From:Subject:From;
	b=fMaAqrwmaanB3Ag/RE62arxoJ73iJF/X642ATfW4i1FtZ6C/QSOtzT5hogYJ9nNGM
	 qcITSmVnTZ9ny73FpBzH3731kPTRUFIt2I6AZlo8ZTIQ+hLJrZLZSRUs88QGHS11p8
	 itYh/sMq6+QCFKaxLxG0WAGPbhuvJSwWzNMpKcHU=
Date: Fri, 05 Sep 2025 18:44:45 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@ucw.cz,mchehab@kernel.org,len.brown@intel.com,james.bottomley@HansenPartnership.com,gregkh@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kernelh-add-comments-for-system_states.patch removed from -mm tree
Message-Id: <20250906014446.174E6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel.h: add comments for system_states
has been removed from the -mm tree.  Its filename was
     kernelh-add-comments-for-system_states.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel.h: add comments for system_states
Date: Wed, 3 Sep 2025 23:36:31 -0700

Provide some basic comments about the system_states and what they imply. 
Also convert the comments to kernel-doc format.

However, kernel-doc does not support kernel-doc notation on extern
struct/union/typedef/enum/etc.  So I made this a DOC: block so that I can
use (insert) it into a Documentation (.rst) file and have it look decent.

Link: https://lkml.kernel.org/r/20250904063631.2364995-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-api/pm/devices.rst |    8 ++++++++
 include/linux/kernel.h                  |   18 ++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

--- a/Documentation/driver-api/pm/devices.rst~kernelh-add-comments-for-system_states
+++ a/Documentation/driver-api/pm/devices.rst
@@ -241,6 +241,14 @@ before reactivating its class I/O queues
 More power-aware drivers might prepare the devices for triggering system wakeup
 events.
 
+System states available for drivers
+-----------------------------------
+
+These system states are available for drivers to help them determine how to
+handle state transitions.
+
+.. kernel-doc:: include/linux/kernel.h
+   :doc: General system_states available for drivers
 
 Call Sequence Guarantees
 ------------------------
--- a/include/linux/kernel.h~kernelh-add-comments-for-system_states
+++ a/include/linux/kernel.h
@@ -164,8 +164,22 @@ extern int root_mountflags;
 
 extern bool early_boot_irqs_disabled;
 
-/*
- * Values used for system_state. Ordering of the states must not be changed
+/**
+ * DOC: General system_states available for drivers
+ *
+ * enum system_states - Values used for system_state.
+ *
+ * * @SYSTEM_BOOTING:	%0, no init needed
+ * * @SYSTEM_SCHEDULING:	system is ready for scheduling; OK to use RCU
+ * * @SYSTEM_FREEING_INITMEM: system is freeing all of initmem; almost running
+ * * @SYSTEM_RUNNING:	system is up and running
+ * * @SYSTEM_HALT:	system entered clean system halt state
+ * * @SYSTEM_POWER_OFF:	system entered shutdown/clean power off state
+ * * @SYSTEM_RESTART:	system entered emergency power off or normal restart
+ * * @SYSTEM_SUSPEND:	system entered suspend or hibernate state
+ *
+ * Note:
+ * Ordering of the states must not be changed
  * as code checks for <, <=, >, >= STATE.
  */
 extern enum system_states {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

listh-add-missing-kernel-doc-for-basic-macros.patch

