Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2F4335C7
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 20:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727208455; cv=none; b=W3imz/B34VYrQ3ygkQVFlR+nnuomZIT242t81qQBHVI/sv93DQKB2ttsRY3Bwq10ojU0d+sFLcegaA7CQ62Dz+MU7scFW+B/evPdT6aE+OheCBW316TNE95vab2tOlyl5biIZ7JjQMR9w68O4wgoLOTmDaV2gdRLtu81CM9L0e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727208455; c=relaxed/simple;
	bh=4OraWRh5L7G9ahY7GGnPDIN3QtYi7FX0Mb7OQCB/1qk=;
	h=Date:To:From:Subject:Message-Id; b=QngvIoVjEPspAgyheMYzNfO3kIWqTW8p85GpwyJw7GUjCoI4ObN/upXUDXmO5HGG/Av5bSZ9fab19Ri8+iZEeKiocpQ0YZcnjQyrzpge/jGvXLQ4XZAgXj/2ZXC0x/3XMWBeNvYgwgzUJLCehOyGXq177+qhpYf1zKDTV5f2VqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mp3FcrTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mp3FcrTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50C4C4CEC4;
	Tue, 24 Sep 2024 20:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727208454;
	bh=4OraWRh5L7G9ahY7GGnPDIN3QtYi7FX0Mb7OQCB/1qk=;
	h=Date:To:From:Subject:From;
	b=mp3FcrTWhGKqTal6NrlBSftOMwaXtTAPOc85cdQ+P/xC4FnfS1WKXin722Dfd4+TQ
	 n/q0qg6qoesBrBPEGyoDNvGow3T25F2I3zLA7xAoNTuurkdSyuA9zLQv1oQzCY46nT
	 MQkaMxka2+xAgstRlGGSp+1GBO0y4SocCcaeswGQ=
Date: Tue, 24 Sep 2024 13:07:34 -0700
To: mm-commits@vger.kernel.org,geert@linux-m68k.org,david@redhat.com,akpm@linux-foundation.org,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-split_pte_ptlocks-depend-on-smp.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924200734.A50C4C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make SPLIT_PTE_PTLOCKS depend on SMP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-make-split_pte_ptlocks-depend-on-smp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-split_pte_ptlocks-depend-on-smp.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Guenter Roeck <linux@roeck-us.net>
Subject: mm: make SPLIT_PTE_PTLOCKS depend on SMP
Date: Tue, 24 Sep 2024 08:42:05 -0700

SPLIT_PTE_PTLOCKS depends on "NR_CPUS >= 4".  Unfortunately, that
evaluates to true if there is no NR_CPUS configuration option.  This
results in CONFIG_SPLIT_PTE_PTLOCKS=y for mac_defconfig.  This in turn
causes the m68k "q800" and "virt" machines to crash in qemu if debugging
options are enabled.

Making CONFIG_SPLIT_PTE_PTLOCKS dependent on the existence of NR_CPUS does
not work since a dependency on the existence of a numeric Kconfig entry
always evaluates to false.  Example:

config HAVE_NO_NR_CPUS
       def_bool y
       depends on !NR_CPUS

After adding this to a Kconfig file, "make defconfig" includes:
$ grep NR_CPUS .config
CONFIG_NR_CPUS=64
CONFIG_HAVE_NO_NR_CPUS=y

Defining NR_CPUS for m68k does not help either since many architectures
define NR_CPUS only for SMP configurations.

Make SPLIT_PTE_PTLOCKS depend on SMP instead to solve the problem.

Link: https://lkml.kernel.org/r/20240924154205.1491376-1-linux@roeck-us.net
Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~mm-make-split_pte_ptlocks-depend-on-smp
+++ a/mm/Kconfig
@@ -595,6 +595,7 @@ config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 config SPLIT_PTE_PTLOCKS
 	def_bool y
 	depends on MMU
+	depends on SMP
 	depends on NR_CPUS >= 4
 	depends on !ARM || CPU_CACHE_VIPT
 	depends on !PARISC || PA20
_

Patches currently in -mm which might be from linux@roeck-us.net are

mm-make-split_pte_ptlocks-depend-on-smp.patch

