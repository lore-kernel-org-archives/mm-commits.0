Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B346235C183
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156309; cv=none; b=tlEhCfJQewTBY0+Bgn6OzxMrHnXUxWy595CVfonJ+CGUZFWgopG0i7zTjVw48b1l4b6fD0Re6fX4/nxB6I+cLbAZgvtHX26wgv3+IObfoUSz40DB/TbA4+DrnpBdErBm6rU9paIcRCTHGl2MLcLS4Bj99xLHA8TcKy/UiT//3qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156309; c=relaxed/simple;
	bh=Qtbh36UvDFk6mOaSaM+PsrOmQr/L4f+xGnAFIRyMmPk=;
	h=Date:To:From:Subject:Message-Id; b=ctJ1lReZWrW4kzcZvskIntvBPYe0i/iI/ZRSbKDGXFkDEXl3PWfi9mm7sHA+3/rY/+qLKTR0cIRUyTcm0xCTKd65Izql9DGw9WgiIQeNvPS59NHm/aJNnRd8tDJsLkjNiTsf35td0N4+dkRLfIVAgZ5YmNlnIemgZGDOHPfpfQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0A91XJ5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0A91XJ5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E13C4CEF8;
	Fri, 14 Nov 2025 21:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156309;
	bh=Qtbh36UvDFk6mOaSaM+PsrOmQr/L4f+xGnAFIRyMmPk=;
	h=Date:To:From:Subject:From;
	b=0A91XJ5BccCxs2o9aZmDUIHEwRb67n7fpJ9kjNGxrq/NVDrUhg0qZhj46sy0a9l7E
	 GSNQsZj7LrB8IaIT9jUdB/p2proiDZK8RJP7h4mTkWpBX/un8ViregHKXAxr+/9QCa
	 C/mnTcyxSl3tc7tNDmAYO+SJS/IRHOhkfHKSPwds=
Date: Fri, 14 Nov 2025 13:38:27 -0800
To: mm-commits@vger.kernel.org,zhangguopeng@kylinos.cn,yoann.congal@smile.fr,yesanishhere@gmail.com,witu@nvidia.com,wagi@kernel.org,vincent.guittot@linaro.org,tj@kernel.org,tglx@linutronix.de,stuart.w.hayes@gmail.com,song@kernel.org,skhawaja@google.com,saeedm@nvidia.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,rdunlap@infradead.org,quic_zijuhu@quicinc.com,ptyadav@amazon.de,pratyush@kernel.org,parav@nvidia.com,pahsa.tatashin@soleen.com,ojeda@kernel.org,myungjoo.ham@samsung.com,mmaurer@google.com,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,lukas@wunner.de,linux@weissschuh.net,leonro@nvidia.com,leon@kernel.org,lennart@poettering.net,kanie@linux.alibaba.com,Jonathan.Cameron@huawei.com,joel.granados@kernel.org,jgg@nvidia.com,jannh@google.com,ira.weiny@intel.com,ilpo.jarvinen@linux.intel.com,hughd@google.com,hpa@zytor.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,graf@amazon.com,dmatlack@google.com,djeffery@redhat.com,david@redhat.com,dan.j.williams@intel.com,dakr@kernel.org,cw00.choi@samsung.com,corbet@lwn.net,chrisl@kernel.org,chenridong@huawei.com,brauner@kernel.org,bp@alien8.de,bhelgaas@google.com,bartosz.golaszewski@linaro.org,axboe@kernel.dk,anna.schumaker@oracle.com,andriy.shevchenko@linux.intel.com,aliceryhl@google.com,aleksander.lobakin@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] liveupdate-kconfig-make-debugfs-optional.patch removed from -mm tree
Message-Id: <20251114213829.05E13C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: Kconfig: make debugfs optional
has been removed from the -mm tree.  Its filename was
     liveupdate-kconfig-make-debugfs-optional.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: Kconfig: make debugfs optional
Date: Fri, 7 Nov 2025 16:03:02 -0500

Now, that LUO can drive KHO state internally, the debugfs API became
optional, so remove the default config.

Link: https://lkml.kernel.org/r/20251107210526.257742-5-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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
Cc: David Matlack <dmatlack@google.com>
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
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Myugnjoo Ham <myungjoo.ham@samsung.com>
Cc: Parav Pandit <parav@nvidia.com>
Cc: Pasha Tatashin <pahsa.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
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
Cc: zhangguopeng <zhangguopeng@kylinos.cn>
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/liveupdate/Kconfig~liveupdate-kconfig-make-debugfs-optional
+++ a/kernel/liveupdate/Kconfig
@@ -55,7 +55,6 @@ config KEXEC_HANDOVER_DEBUG
 
 config KEXEC_HANDOVER_DEBUGFS
 	bool "kexec handover debugfs interface"
-	default KEXEC_HANDOVER
 	depends on KEXEC_HANDOVER
 	select DEBUG_FS
 	help
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

lib-test_kho-check-if-kho-is-enabled.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
kho-fix-misleading-log-message-in-kho_populate.patch
kho-convert-__kho_abort-to-return-void.patch
kho-introduce-high-level-memory-allocation-api.patch
kho-preserve-fdt-folio-only-once-during-initialization.patch
kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch
kho-always-expose-output-fdt-in-debugfs.patch
kho-simplify-serialization-and-remove-__kho_abort.patch
kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch
kho-remove-abort-functionality-and-support-state-refresh.patch
kho-update-fdt-dynamically-for-subtree-addition-removal.patch
kho-allow-kexec-load-before-kho-finalization.patch
kho-allow-memory-preservation-state-updates-after-finalization.patch
kho-add-kconfig-option-to-enable-kho-by-default.patch
liveupdate-luo_core-luo_ioctl-live-update-orchestrator.patch
liveupdate-luo_core-integrate-with-kho.patch
reboot-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_ioctl-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation-and-state-management.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-kexec-based-selftest-for-session-lifecycle.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

