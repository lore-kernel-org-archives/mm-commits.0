Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71059C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 11:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbhLMLbS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 06:31:18 -0500
Received: from mail-mw2nam10on2070.outbound.protection.outlook.com ([40.107.94.70]:14432
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232478AbhLMLbR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Dec 2021 06:31:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLjyyor0VMaoLzyFk/Ah8WOxJlpt9xmYxYHPvD/hA/P5ndySGDFOg+TaKmvdhHOikq0p9/iVq1DnMJGx3ERlc5ED7ZI2rEX15wA3FO+Qo2Y+T2FihshfWRuJon2MEIIpt/gYxNHIQO2gjGH8mmQWbgw09B/4hI0r8k20qpy/GZBcSslThK4Fk/uNjceaKFBCt+aw8nskNZSmLRy/hIS/Ab2xU543DiQtI+l2ci0Rr+kIUhAHITwVwuht2B1I07iLnKyZZX3HdIoF9fpEsWRCW6pK/TLU940PmgjkIyNA3lWJRoo3R21rnh1OlO9MvrheDVW5PATxIieDc/VFehBYWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RDreBGilSY4acXi0rbH4208ERM6M/1oI9+Nne/VkU3U=;
 b=diI2/coAbmGwoMsm2cAtixi4vxoBb6iPv6XPZaNEkRAWAE6N91N0Gl7htQPPCU44fFRbzyXiLa+ARdSB1VgbKADCgttw9EWv2jaxOSKjhMqJ38RhdkHEofzy+zJdKqt8Key9rPkzWliasWEVb6F38s7gzOo5JBEGhKedbO5uKAjb7OIEb+L9Vx3xYF7Gqj7sL0hI9Nzq+W88pUxI6lU/bs1nfcJ7tGyX5Kyjnnq/A9qNTAYaPz1hlpz2COlrOORnrc+prPn2/eGx0kRh0hi2WicyWAXhlVve7vLDzxnw/xV9dx54+iWYI/ss+ZaafM/nobhBNN/ENm0qppq6tBs5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDreBGilSY4acXi0rbH4208ERM6M/1oI9+Nne/VkU3U=;
 b=eFym2OpjSDg85nkdVo9jfky5fhT0lnhPgpGVBg/dlvJQ+leupS++cxw4+d9KkgjQS8Mwt1Q9xLA6Yh6vJFh8Olg5vcckXt13JrBKaSY66ueS61cYyK1SA9BOsKIu/cd/Xx6TMQkwSMi/TTyTEuQIcXyg2ZIVOD4yuFuPdgvRH7cJdXYZzb3j5H8rZnO309HIEocj4aYh6XPF4qPx7j2h2LLbFucuymolOmn4PIrJYZCzwCTB7IAjVa2RynP2q85lgR8QM96KoPus1jnatMQwb3MDMPdxqJOIo4zRl8lMPV7QGCTdhTUtX/6XVt3/zDr7eVStl0wxD/mtGPatBArf+Q==
Received: from MWHPR1601CA0018.namprd16.prod.outlook.com
 (2603:10b6:300:da::28) by MW2PR12MB2490.namprd12.prod.outlook.com
 (2603:10b6:907:9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Mon, 13 Dec
 2021 11:31:16 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::a2) by MWHPR1601CA0018.outlook.office365.com
 (2603:10b6:300:da::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14 via Frontend
 Transport; Mon, 13 Dec 2021 11:31:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 11:31:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 11:31:08 +0000
Received: from nvdebian.localnet (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 13 Dec 2021
 03:31:04 -0800
From:   Alistair Popple <apopple@nvidia.com>
To:     <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>
CC:     <dhowells@redhat.com>, <hughd@google.com>, <jgg@nvidia.com>,
        <jglisse@redhat.com>, <jhubbard@nvidia.com>,
        <mm-commits@vger.kernel.org>, <rcampbell@nvidia.com>
Subject: Re: + mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch added to -mm tree
Date:   Mon, 13 Dec 2021 22:30:55 +1100
Message-ID: <2420988.TeagO0yf0P@nvdebian>
In-Reply-To: <YbQqXKrwVtr+HRLe@casper.infradead.org>
References: <20211118215427.csLE2tPWS%akpm@linux-foundation.org> <YbQqXKrwVtr+HRLe@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17b926af-cbba-4e5f-c0c7-08d9be2c1361
X-MS-TrafficTypeDiagnostic: MW2PR12MB2490:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2490F6E3B822996D7CCE8C2EDF749@MW2PR12MB2490.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RxCw8/SzpFnXiBhaZz88KMDKIwlQNhH0grq0VQXBHkzWRIQsMrJBGT+DNQvD+qiixSNSIiVmQ1AC9tLp+wNt71rWr+TIklmDC5HtymuzEieryTP1PiyEhWS0rCOkUF7FEdSl0/TyqrDa8VuEdBM7GWhI4bwlWdji/xnV7Byg+B0snXAM9KlS6pY8kb685jMf9MBvxVpFSpy98M8Ffsd1p2X/HlKOkRHMVrv2aIhiSS0IztVP7A0GgeKn6Dt1Dmb/FJJ7G0rvZQfGRci913BBROVsp0G2KzEwGEKUV2la71mhXS4XnQ8LBdO5Ss/iB3rDrjxt4CiwE9is6UWz2XUgKXEi8fS0eY3PnUUKnl0nLIJpHix3gu1KTTOMKF83J1R2/kbi4eQgqUwIBkSfbyIVHCuvLUimdNpN46hBCt2J178oBSe8OL6yKWotKJN1UqZQSzeK9XYuNnRxMJVNPrOyVy+ZKFIzzdlk+jLkcii97L4hsECrmgKHiPa4SnTnGt5hPXcGPCYTR695EdLs1zM00RCOtzfAH5Nl8rhrJA3QGCVHF3kzO36Luc4lpqPDOsw1hUHhsCzfxXD8yDhHLaefyurQnv9QqU3CZnJE/x8mGpt5g4B7bh31qt26iF7sLOi0mAse/uD3RH7piCsBEjIY3RAYJZwCXOoGmaUzsZRNUoDota1otuiDd3oLul4ZGkrkvmpBRMaaqJGIO2adnbekyQgT3CkAu3uk3o8zVhjo8Q6lgD+wwVOlYS9Dle3UbNgDX6woTo4yF018ImUNYtdSI7O/G1mJmYCPJowrvYf9c4vSwCv+FXDG8X9/DOIdkqDd
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(33716001)(9686003)(34070700002)(47076005)(336012)(356005)(8676002)(110136005)(2906002)(9576002)(54906003)(4326008)(6666004)(426003)(70206006)(7636003)(70586007)(316002)(5660300002)(508600001)(107886003)(36860700001)(86362001)(186003)(16526019)(83380400001)(26005)(8936002)(82310400004)(40460700001)(39026012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 11:31:15.9184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b926af-cbba-4e5f-c0c7-08d9be2c1361
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2490
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Saturday, 11 December 2021 3:34:36 PM AEDT Matthew Wilcox wrote:
> On Thu, Nov 18, 2021 at 01:54:27PM -0800, akpm@linux-foundation.org wrote:
> > +++ a/mm/migrate.c
> > @@ -305,15 +305,7 @@ void __migration_entry_wait(struct mm_st
> >  	page = pfn_swap_entry_to_page(entry);
> >  	page = compound_head(page);
> >  
> > -	/*
> > -	 * Once page cache replacement of page migration started, page_count
> > -	 * is zero; but we must not call put_and_wait_on_page_locked() without
> > -	 * a ref. Use get_page_unless_zero(), and just fault again if it fails.
> > -	 */
> > -	if (!get_page_unless_zero(page))
> > -		goto out;
> > -	pte_unmap_unlock(ptep, ptl);
> > -	put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
> > +	migration_entry_wait_on_locked(page_folio(page), ptep, ptl);
> 
> This is clearly bogus.  The 'page = compound_head(page)' line should
> be deleted.
> 
> But I think we should go further and turn this into:
> 
> 	migration_entry_wait_on_locked(entry, ptep, ptl);
> 
> Neither caller has anything useful to do with the page any more.

Thanks for spotting that, I have posted a new version which does that.



