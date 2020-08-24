Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8B8C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 464682072D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598306150;
	bh=ZyZEYdwrxazghiX8qBefbqInbUd/bfd9x/NvH89I/Rg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u7shkH5eGD4Ghmd803Ief3oF12NFxMMaiO3Nok5wkM7hEegy7KnFqaWHQsYBoPcT7
	 Uy82KzgCv7ZtyvQdhzYyevrtjaZyqvr6BmCZkhpVkInCCjPfjKJXotil8xstdlVZf3
	 B/CD1qmfgVbjViTr/cWr0nC1RQ+DliEFhUjZICRE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHXVzu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXVzt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 17:55:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9DA2204EA;
        Mon, 24 Aug 2020 21:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598306149;
        bh=ZyZEYdwrxazghiX8qBefbqInbUd/bfd9x/NvH89I/Rg=;
        h=Date:From:To:Subject:From;
        b=vs1+NwSRoaTq3xInlmRry+JdVpMQNkCF8R31xhdcC/XRRRqzUpH0YgfglIOj2ltPm
         8zzsst4cFQ+mNyWeBZblND0/58xtbIXX5aTU26iJnEvSjhAfvGWw4kYqxQmvdH6DLF
         nRPalOd+QWlOOQ68AegQSjZVq7JuZJbNMqhZ07A0=
Date:   Mon, 24 Aug 2020 14:55:48 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, kishon@ti.com, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, vkoul@kernel.org
Subject:  + const_structscheckpatch-add-phy_ops.patch added to -mm
 tree
Message-ID: <20200824215548.M0ztETJE5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add phy_ops
has been added to the -mm tree.  Its filename is
     const_structscheckpatch-add-phy_ops.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/const_structscheckpatch-add-phy_ops.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/const_structscheckpatch-add-phy_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: const_structs.checkpatch: add phy_ops

All usages of phy_ops in include/linux uses const phy_ops * and all
instances of phy_ops in the kernel that are not const already can be made
const (patches have been posted for those separately).

Link: https://lkml.kernel.org/r/20200824214132.9072-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-phy_ops
+++ a/scripts/const_structs.checkpatch
@@ -39,6 +39,7 @@ nlmsvc_binding
 nvkm_device_chip
 of_device_id
 pci_raw_ops
+phy_ops
 pipe_buf_operations
 platform_hibernation_ops
 platform_suspend_ops
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

const_structscheckpatch-add-phy_ops.patch

