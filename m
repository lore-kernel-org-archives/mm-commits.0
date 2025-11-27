Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3381313283
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282393; cv=none; b=H2X0SESN29qi+TmMNOFVmZj1t5QBvIm9Ax7YayzLwLjw1Q8Z3/cdV0r6d7viG4sMNNeYXKCB9walwApsTUOAa4W3GQewNNywWBI7NRlhXNEWC+m7HBcTv5aKU5vZ47PIW/vQ6+6lk5K3NDaIH1YLo8i4klWiZFmoeywmNo6obq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282393; c=relaxed/simple;
	bh=f1UbeQqdJ9VCD8yiVbEfyxl6zZcod8AdIvlPvG0r15E=;
	h=Date:To:From:Subject:Message-Id; b=ot7rgtAfxzXvRtcH6+qucul+HjXTfeg2bYXXU1EtcJ7A8HGCX2/aEL2km5LCQOEmY3NYO8zr+jhsx42/qKBK33GmiSOqb63w/saoNyQLMNq134vH47OVyDz55UaV+QbUJDHpT4xaTBcEP9j5/mIgTHkaXhrSc/zpPt7DSJ1v6YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Voh9xBJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Voh9xBJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748F4C4CEF8;
	Thu, 27 Nov 2025 22:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282393;
	bh=f1UbeQqdJ9VCD8yiVbEfyxl6zZcod8AdIvlPvG0r15E=;
	h=Date:To:From:Subject:From;
	b=Voh9xBJu8qG2b7KhsxY+JIOoojMNJt0UdrC8MhO4/RITaKaT3QcOKnjRjoUG454av
	 nqLIl8MvZJuqT/K1nmjbTLw7awdktfrFhWbg6Jnqw0SkNOZtubwCvUG6/cG4uQQxAZ
	 nCO/f2h49P465rjjFTJWnEAzJaGelY1ekaIIrej4=
Date: Thu, 27 Nov 2025 14:26:33 -0800
To: mm-commits@vger.kernel.org,yoann.congal@smile.fr,yesanishhere@gmail.com,yanjun.zhu@linux.dev,witu@nvidia.com,wagi@kernel.org,vincent.guittot@linaro.org,tj@kernel.org,tglx@linutronix.de,stuart.w.hayes@gmail.com,song@kernel.org,skhawaja@google.com,saeedm@nvidia.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,rdunlap@infradead.org,quic_zijuhu@quicinc.com,ptyadav@amazon.de,pratyush@kernel.org,parav@nvidia.com,ojeda@kernel.org,myungjoo.ham@samsung.com,mmaurer@google.com,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,lukas@wunner.de,linux@weissschuh.net,leonro@nvidia.com,leon@kernel.org,lennart@poettering.net,kanie@linux.alibaba.com,Jonathan.Cameron@huawei.com,joel.granados@kernel.org,jgg@nvidia.com,jannh@google.com,ira.weiny@intel.com,ilpo.jarvinen@linux.intel.com,hughd@google.com,hpa@zytor.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,graf@amazon.com,dmatlack@google.com,djeffery@redhat.com,david@redhat.com,dan.j.williams@intel.com,dakr@kernel.org,cw00.choi@samsung.com,corbet@lwn.net,chrisl@kernel.org,chenridong@huawei.com,brauner@kernel.org,bp@alien8.de,bhelgaas@google.com,bartosz.golaszewski@linaro.org,axboe@kernel.dk,anna.schumaker@oracle.com,andriy.shevchenko@linux.intel.com,aliceryhl@google.com,aleksander.lobakin@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-call-liveupdate_reboot-before-kexec.patch removed from -mm tree
Message-Id: <20251127222633.748F4C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: call liveupdate_reboot() before kexec
has been removed from the -mm tree.  Its filename was
     kexec-call-liveupdate_reboot-before-kexec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kexec: call liveupdate_reboot() before kexec
Date: Tue, 25 Nov 2025 11:58:33 -0500

Modify the kernel_kexec() to call liveupdate_reboot().

This ensures that the Live Update Orchestrator is notified just before the
kernel executes the kexec jump.  The liveupdate_reboot() function triggers
the final freeze event, allowing participating FDs perform last-minute
check or state saving within the blackout window.

If liveupdate_reboot() returns an error (indicating a failure during LUO
finalization), the kexec operation is aborted to prevent proceeding with
an inconsistent state.  An error is returned to user.

Link: https://lkml.kernel.org/r/20251125165850.3389713-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Tested-by: David Matlack <dmatlack@google.com>
Cc: Aleksander Lobakin <aleksander.lobakin@intel.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: anish kumar <yesanishhere@gmail.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Wagner <wagi@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Jeffery <djeffery@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guixin Liu <kanie@linux.alibaba.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Myugnjoo Ham <myungjoo.ham@samsung.com>
Cc: Parav Pandit <parav@nvidia.com>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: William Tu <witu@nvidia.com>
Cc: Yoann Congal <yoann.congal@smile.fr>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/kexec_core.c~kexec-call-liveupdate_reboot-before-kexec
+++ a/kernel/kexec_core.c
@@ -15,6 +15,7 @@
 #include <linux/kexec.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/liveupdate.h>
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
@@ -1137,6 +1138,10 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	error = liveupdate_reboot();
+	if (error)
+		goto Unlock;
+
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		/*
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

