Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E7315667F
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 21:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712179900; cv=none; b=Hk+6C+QPPEX0BfCpB74HOI5h75CMtL8jZzTVNBdfMLnOuDOc9DnF0FXl4370uO87zbnX0f+XS7VfnKZubIfHhz9hsxeaigucpfYR3+fkuXqjAJ0ktThnv3HSAt6sb/h49jNIpniKGocVhXV6C5jzl+4vxjgu1eaGT1WLOLGPFiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712179900; c=relaxed/simple;
	bh=oeYKhzouomGNclp2v7PejSgf2WhDEwo4I1NfIXII4VA=;
	h=Date:To:From:Subject:Message-Id; b=iLl6JM49+00IG4pAeoUCXaFjIS3ap2EIWJdhVLrgsmCwmOnRE4v2t1+ybJlyTSNAvTDP/BMmJkehkBoTS56xCSPQ9pfX5oApq+b3EO9JBTe3G5ojB0h3oAdbG0A1hMfgJdaJS6cHv3yqhZrl+jMLQqgHpvvyWzVWB3qgfUlzHnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c+/LtbQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c+/LtbQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E77C433C7;
	Wed,  3 Apr 2024 21:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712179900;
	bh=oeYKhzouomGNclp2v7PejSgf2WhDEwo4I1NfIXII4VA=;
	h=Date:To:From:Subject:From;
	b=c+/LtbQGlAgH/P0yMmel9l1XxxLvh+YafSaNaU7PtYYJLhSiMOHWlqRwd7xJn7IN8
	 WCO7Jqq/8S/anM1lIjWaSax9jOggJTvVsAGGSSPqBLuTi5wCiwk+7kD0jeRHdbr6Uf
	 XlPCE7jKYlEeDVb1LXaZ6RcqNALMDdYqztiuwpI4=
Date: Wed, 03 Apr 2024 14:31:39 -0700
To: mm-commits@vger.kernel.org,vishnu.dasa@broadcom.com,vishal.bhakta@broadcom.com,ronak.doshi@broadcom.com,nick.shi@broadcom.com,gregkh@linuxfoundation.org,florian.fainelli@broadcom.com,bryan-bt.tan@broadcom.com,ajay.kaher@broadcom.com,alexey.makhalov@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-change-vmwarecom-addresses-to-broadcomcom.patch added to mm-hotfixes-unstable branch
Message-Id: <20240403213140.21E77C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: change vmware.com addresses to broadcom.com
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-change-vmwarecom-addresses-to-broadcomcom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-change-vmwarecom-addresses-to-broadcomcom.patch

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
From: Alexey Makhalov <alexey.makhalov@broadcom.com>
Subject: MAINTAINERS: change vmware.com addresses to broadcom.com
Date: Tue, 2 Apr 2024 16:23:34 -0700

Update all remaining vmware.com email addresses to actual broadcom.com.

Add corresponding .mailmap entries for maintainers who contributed in the
past as the vmware.com address will start bouncing soon.

Maintainership update. Jeff Sipek has left VMware, Nick Shi will be
maintaining VMware PTP.

Link: https://lkml.kernel.org/r/20240402232334.33167-1-alexey.makhalov@broadcom.com
Signed-off-by: Alexey Makhalov <alexey.makhalov@broadcom.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Acked-by: Ajay Kaher <ajay.kaher@broadcom.com>
Acked-by: Ronak Doshi <ronak.doshi@broadcom.com>
Acked-by: Nick Shi <nick.shi@broadcom.com>
Acked-by: Bryan Tan <bryan-bt.tan@broadcom.com>
Acked-by: Vishnu Dasa <vishnu.dasa@broadcom.com>
Acked-by: Vishal Bhakta <vishal.bhakta@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    5 +++++
 MAINTAINERS |   46 +++++++++++++++++++++++-----------------------
 2 files changed, 28 insertions(+), 23 deletions(-)

--- a/.mailmap~maintainers-change-vmwarecom-addresses-to-broadcomcom
+++ a/.mailmap
@@ -20,6 +20,7 @@ Adam Oldham <oldhamca@gmail.com>
 Adam Radford <aradford@gmail.com>
 Adriana Reus <adi.reus@gmail.com> <adriana.reus@intel.com>
 Adrian Bunk <bunk@stusta.de>
+Ajay Kaher <ajay.kaher@broadcom.com> <akaher@vmware.com>
 Akhil P Oommen <quic_akhilpo@quicinc.com> <akhilpo@codeaurora.org>
 Alan Cox <alan@lxorguk.ukuu.org.uk>
 Alan Cox <root@hraefn.swansea.linux.org.uk>
@@ -36,6 +37,7 @@ Alexei Avshalom Lazar <quic_ailizaro@qui
 Alexei Starovoitov <ast@kernel.org> <alexei.starovoitov@gmail.com>
 Alexei Starovoitov <ast@kernel.org> <ast@fb.com>
 Alexei Starovoitov <ast@kernel.org> <ast@plumgrid.com>
+Alexey Makhalov <alexey.amakhalov@broadcom.com> <amakhalov@vmware.com>
 Alex Hung <alexhung@gmail.com> <alex.hung@canonical.com>
 Alex Shi <alexs@kernel.org> <alex.shi@intel.com>
 Alex Shi <alexs@kernel.org> <alex.shi@linaro.org>
@@ -110,6 +112,7 @@ Brendan Higgins <brendan.higgins@linux.d
 Brian Avery <b.avery@hp.com>
 Brian King <brking@us.ibm.com>
 Brian Silverman <bsilver16384@gmail.com> <brian.silverman@bluerivertech.com>
+Bryan Tan <bryan-bt.tan@broadcom.com> <bryantan@vmware.com>
 Cai Huoqing <cai.huoqing@linux.dev> <caihuoqing@baidu.com>
 Can Guo <quic_cang@quicinc.com> <cang@codeaurora.org>
 Carl Huang <quic_cjhuang@quicinc.com> <cjhuang@codeaurora.org>
@@ -529,6 +532,7 @@ Rocky Liao <quic_rjliao@quicinc.com> <rj
 Roman Gushchin <roman.gushchin@linux.dev> <guro@fb.com>
 Roman Gushchin <roman.gushchin@linux.dev> <guroan@gmail.com>
 Roman Gushchin <roman.gushchin@linux.dev> <klamm@yandex-team.ru>
+Ronak Doshi <ronak.doshi@broadcom.com> <doshir@vmware.com>
 Muchun Song <muchun.song@linux.dev> <songmuchun@bytedance.com>
 Muchun Song <muchun.song@linux.dev> <smuchun@gmail.com>
 Ross Zwisler <zwisler@kernel.org> <ross.zwisler@linux.intel.com>
@@ -651,6 +655,7 @@ Viresh Kumar <vireshk@kernel.org> <vires
 Viresh Kumar <vireshk@kernel.org> <viresh.linux@gmail.com>
 Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.org>
 Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.com>
+Vishnu Dasa <vishnu.dasa@broadcom.com> <vdasa@vmware.com>
 Vivek Aknurwar <quic_viveka@quicinc.com> <viveka@codeaurora.org>
 Vivien Didelot <vivien.didelot@gmail.com> <vivien.didelot@savoirfairelinux.com>
 Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
--- a/MAINTAINERS~maintainers-change-vmwarecom-addresses-to-broadcomcom
+++ a/MAINTAINERS
@@ -16731,9 +16731,9 @@ F:	include/uapi/linux/ppdev.h
 
 PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
-R:	Ajay Kaher <akaher@vmware.com>
-R:	Alexey Makhalov <amakhalov@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+R:	Ajay Kaher <ajay.kaher@broadcom.com>
+R:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	virtualization@lists.linux.dev
 L:	x86@kernel.org
 S:	Supported
@@ -23652,9 +23652,9 @@ S:	Supported
 F:	drivers/misc/vmw_balloon.c
 
 VMWARE HYPERVISOR INTERFACE
-M:	Ajay Kaher <akaher@vmware.com>
-M:	Alexey Makhalov <amakhalov@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+M:	Ajay Kaher <ajay.kaher@broadcom.com>
+M:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	virtualization@lists.linux.dev
 L:	x86@kernel.org
 S:	Supported
@@ -23663,34 +23663,34 @@ F:	arch/x86/include/asm/vmware.h
 F:	arch/x86/kernel/cpu/vmware.c
 
 VMWARE PVRDMA DRIVER
-M:	Bryan Tan <bryantan@vmware.com>
-M:	Vishnu Dasa <vdasa@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+M:	Bryan Tan <bryan-bt.tan@broadcom.com>
+M:	Vishnu Dasa <vishnu.dasa@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/hw/vmw_pvrdma/
 
 VMWARE PVSCSI DRIVER
-M:	Vishal Bhakta <vbhakta@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+M:	Vishal Bhakta <vishal.bhakta@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/vmw_pvscsi.c
 F:	drivers/scsi/vmw_pvscsi.h
 
 VMWARE VIRTUAL PTP CLOCK DRIVER
-M:	Jeff Sipek <jsipek@vmware.com>
-R:	Ajay Kaher <akaher@vmware.com>
-R:	Alexey Makhalov <amakhalov@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+M:	Nick Shi <nick.shi@broadcom.com>
+R:	Ajay Kaher <ajay.kaher@broadcom.com>
+R:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/ptp/ptp_vmw.c
 
 VMWARE VMCI DRIVER
-M:	Bryan Tan <bryantan@vmware.com>
-M:	Vishnu Dasa <vdasa@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+M:	Bryan Tan <bryan-bt.tan@broadcom.com>
+M:	Vishnu Dasa <vishnu.dasa@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/misc/vmw_vmci/
@@ -23705,16 +23705,16 @@ F:	drivers/input/mouse/vmmouse.c
 F:	drivers/input/mouse/vmmouse.h
 
 VMWARE VMXNET3 ETHERNET DRIVER
-M:	Ronak Doshi <doshir@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+M:	Ronak Doshi <ronak.doshi@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/vmxnet3/
 
 VMWARE VSOCK VMCI TRANSPORT DRIVER
-M:	Bryan Tan <bryantan@vmware.com>
-M:	Vishnu Dasa <vdasa@vmware.com>
-R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
+M:	Bryan Tan <bryan-bt.tan@broadcom.com>
+M:	Vishnu Dasa <vishnu.dasa@broadcom.com>
+R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	net/vmw_vsock/vmci_transport*
_

Patches currently in -mm which might be from alexey.makhalov@broadcom.com are

maintainers-change-vmwarecom-addresses-to-broadcomcom.patch

