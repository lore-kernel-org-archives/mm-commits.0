Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3805C4338F
	for <mm-commits@archiver.kernel.org>; Sun,  8 Aug 2021 21:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA3360F02
	for <mm-commits@archiver.kernel.org>; Sun,  8 Aug 2021 21:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhHHVNC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 8 Aug 2021 17:13:02 -0400
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:14688
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229895AbhHHVNC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 8 Aug 2021 17:13:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5vyU1FLu1xaDz6F8CQ6Fuw/eTaz2t+6wBaKjww5VxpkwN4s0KBwPHOGe2QcG20WQlHbDvP4POk9r6hg9gVKIWSl2QK7y7MOpVrW4fI7S6Plr2j5WFAUXPXH/RXxy6UJ4oR9CJodIXFDeC3ZDTnEfdqFFIUd+BVjHw9jwJJHDBMRYbwrr99yotS8LfmqtmT0XBR84z/bcEz/pP73j/NKEi+NiJfKid2c2tGo5lNxhTB4+fl8UXQeFkmETJ2xqdJWogdvouuTAkuy0AFxS6Hs79Ht5WRKoLnzf5CztWxi85dSzh7+sGMGcMlwdkKvtnyFB10u+guPURS7Y3g4nITWpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1Z3g8bR2CSzzAmLUorTPf9lxmXLyynDpVOXm74UTlM=;
 b=hq8CO+BIUPb99FWReAWgvMQTIMD5gmZsfrFIdTQJL3Y6FZWSlnf26U2/weYJmyulpRc4ypvJSQI6HmfAUjKcAApOy1M5g9KMjig00mtYBoI+U2PyvpQrYF3Dd1GG4Wm+tFJRAt0aRcRANTm7yQp29IsBBG4gPJqNItyQbZCvRrWpoxRKaE+tpUhN2XCxvyqKelykkQN+9PpcvghVMxJpYFBgoKpxSD2utT2AFi1A/OT8OL39Ti0HykGubczYhaHC3QMqYl60mxxCfcy/8BkM82yWZKJChi0by+OAKLLnyEzd3H9hpkWqQ0sGJYdfTXhmfwepPby0gMXsBplZ952n4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1Z3g8bR2CSzzAmLUorTPf9lxmXLyynDpVOXm74UTlM=;
 b=L12fzN2jV3QXfSocOg3Z52zYcIr7BBUp8Ef8wedHBXpEQQiKhy32dfGlDZAHdkVGShVDS0blpdP0Sh2TlxgU5QoVMRHo6hO+x979DaPZNxmiKTtp6NYc5GfB6noQvIoDD0PlKng/JpZhrxp2/aYXd/C7siwHUBhwCpUxGRlVfz3ehksZYdE6rXsI+te31ehzzx43WGFV5ZGciVocbu5xWkWfuQtFA1xsVqBZFH33tubs0702u1eh4iZrU8PWH9/OHDkMD9/hBwsg/1VUqaz/WADpH56J2ztq0ouPDxPnsWWRpErIjfTV1jxop2+J+xBJiBqTC2/59geIcCtIhdOEjA==
Received: from BN8PR15CA0048.namprd15.prod.outlook.com (2603:10b6:408:80::25)
 by BY5PR12MB3796.namprd12.prod.outlook.com (2603:10b6:a03:1ae::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Sun, 8 Aug
 2021 21:12:41 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::10) by BN8PR15CA0048.outlook.office365.com
 (2603:10b6:408:80::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Sun, 8 Aug 2021 21:12:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 21:12:40 +0000
Received: from [10.2.53.40] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 8 Aug
 2021 21:12:39 +0000
Subject: Re: +
 mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
 added to -mm tree
To:     <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
        <linmiaohe@huawei.com>, <kirill.shutemov@linux.intel.com>,
        <jack@suse.cz>, <imbrenda@linux.ibm.com>
References: <20210807184607.cyXFb%akpm@linux-foundation.org>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <ade20d04-ca72-e682-0fc8-63588506e0cb@nvidia.com>
Date:   Sun, 8 Aug 2021 14:12:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210807184607.cyXFb%akpm@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 671f3daf-3a35-450a-acd9-08d95ab141d9
X-MS-TrafficTypeDiagnostic: BY5PR12MB3796:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3796CFC3BBF41BE0A70B9458A8F59@BY5PR12MB3796.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9i7SSzCmIaSofbFnBQvIuT2o1bisMFYUoaPymvuQPL9+4G1Shogf/8gMB+MkvCogVIeDPQTTpOCH5gEI1rOSmDoOhm72DCEEe1dGX2omjiU7zwhmRQ5L58G3sL8e2vzNuUj4UfXWwMZTmq+HhwXhUuycwbCgfiVVpiiv62zU0eqiQZBlPyH6UoF73+vbRYww1fLjctwLKNJXmMPrSBnhzu2pT0aBH4fPM4ZISO/9upg22Qw5zXt9cpJF3kb9R0dHwSkQa9XHc0hvPCq59otHHsZuN+paStzEGl16QaNY/2wbmeMpXyChANwIFnN5kC/mLe8UY+K52n8V6eU/R/dJPk5HIVZF5mgZN7woqpaDaSLkAt7AiuCOAOx4WcRID1awPs1GLNmWHypCUZbi8Fn/oWb48HY3S+UTe716TD1KMoaeO4ecEqMWZYwyf5rcq66qWweYfGblsLryspt1iIGlgOH9QL10/IFhbjnxzHPoaV8QedysjX7m/XsoHY3U2ldHHKQu2LsSOBQoa6oynauu3krYHqUpbVbrNVpGGpHaUFNmKRQkk9il7Da2sckpTsn5Cpq/1vMiUkc7/ofQj8sHseLiwoKUe22nUl8BcoBUBH5Iyp/Ii96u8flNafGDyY1Y4+m8yakmAgi3g6JWc3p2pf6KsePBlnCw2ZxQTDGnImDhsvJyW5/YBJma61d3Gv76NfI/dI080wWXKYEc61qDW/eUaV/nGY6xNDfetvC4IQwK8JcujC4TwbxUf7sYltiTzJlgt+ZToglySsa0uKLHZ7LpV1kKtQ6JvIrtPxe2UUvqYWTNs+y+syV7KOUEyV8Je/lW+cS5HWokm1ATKpKMDg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(426003)(2616005)(336012)(47076005)(316002)(31696002)(31686004)(82310400003)(356005)(36756003)(36860700001)(5660300002)(478600001)(186003)(26005)(7636003)(16526019)(83380400001)(16576012)(8936002)(82740400003)(2906002)(53546011)(966005)(36906005)(86362001)(70586007)(110136005)(70206006)(8676002)(14583001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 21:12:40.8522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 671f3daf-3a35-450a-acd9-08d95ab141d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3796
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 8/7/21 11:46 AM, akpm@linux-foundation.org wrote:
> 
> The patch titled
>       Subject: mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix
> has been added to the -mm tree.  Its filename is
>       mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
> 
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix
> 
> fix return value

OK, the end result now looks correct. For the stacked set of fixes here:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard
NVIDIA

> 
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/gup.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/mm/gup.c~mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix
> +++ a/mm/gup.c
> @@ -2240,6 +2240,7 @@ static int __gup_device_huge(unsigned lo
>   {
>   	int nr_start = *nr;
>   	struct dev_pagemap *pgmap = NULL;
> +	int ret = 1;
>   
>   	do {
>   		struct page *page = pfn_to_page(pfn);
> @@ -2247,12 +2248,14 @@ static int __gup_device_huge(unsigned lo
>   		pgmap = get_dev_pagemap(pfn, pgmap);
>   		if (unlikely(!pgmap)) {
>   			undo_dev_pagemap(nr, nr_start, flags, pages);
> +			ret = 0;
>   			break;
>   		}
>   		SetPageReferenced(page);
>   		pages[*nr] = page;
>   		if (unlikely(!try_grab_page(page, flags))) {
>   			undo_dev_pagemap(nr, nr_start, flags, pages);
> +			ret = 0;
>   			break;
>   		}
>   		(*nr)++;
> @@ -2260,7 +2263,7 @@ static int __gup_device_huge(unsigned lo
>   	} while (addr += PAGE_SIZE, addr != end);
>   
>   	put_dev_pagemap(pgmap);
> -	return 1;
> +	return ret;
>   }
>   
>   static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm.patch
> mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
> mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
> lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
> mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
> mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
> mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
> mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
> mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
> mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
> fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
> log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
> linux-next-rejects.patch
> linux-next-git-rejects.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
> 

