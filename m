Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5615ECE79A8
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 22:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbjISWPp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 18:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbjISWPl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 18:15:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03818C6
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 15:15:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38JKgtw7007141;
        Tue, 19 Sep 2023 22:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=SOidmfW2cSFehnL1G7SwSlPZKJoK5MptFWfnws1/hQA=;
 b=o8aRybG86RVSsJa1ZJDz1AXSii0QBel9ObrZHOTdOe3QRShPn2PZkgii0gmpuYvUu7MN
 8qlYKGfdj0FdqZEFVO00LpZo+OzbYapYIhMRJaXmxKZ0KR2LgjTdbpZgVppPfP5Jg4Dq
 e99Gp7dvLcqqXm84lhTtfLhnxK3Ni4ZysSssLlxfiF24n+Pz0kllbnsm/qj0W8pP5UOM
 C8oqCbuGFkmZAOfJqX+2xwBNNbNP9nmbM4o2znQ7jXR/U2LaautzqrHCwxYWLb29ten7
 kQhUHLbk9JCJ2FyLIUo8Llg6gcOh3Hj98yVobKU1WGR1Oxtj8OKk5p+d7zh4HDWKbbQ/ 8Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t5352x25m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Sep 2023 22:15:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38JLg3dr012033;
        Tue, 19 Sep 2023 22:15:17 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t6hkba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Sep 2023 22:15:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Glj0mm9UjeyVX3yao66FDPva6324hVLCsIOFwLLmX0+nA59vYp9Lm9AOajvkG6bjkR9Fm8Tc3YoWEzDOxV6AQHxdVjE4atJbnRLmGovXbahDoFIA31onyMBRUPz3X8kRYfk4XuyC2tAqPNuSctS+LDiZllZmaokZB4tp6/1CfiXvzPjCrh59UoWu3keyZk6soa1CjR368RPu5WoeWYou8jhieXdYuDhGt/DayM2yxeVT9VlT5AnxXLDs2qMljpw/rR5PZVU/qdT3JiXD5E2t/tcDCVYIpp2875aruk6qY4kwSdGZLVM6Ewj8TWxHXI9CPSrgur507nScd3aTMfZ2dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOidmfW2cSFehnL1G7SwSlPZKJoK5MptFWfnws1/hQA=;
 b=NP4pOm7bfAUKcGZq/6vQFyOclhj2lYCGOreDT3+22kCtaAS+ySr58JqNEcz+pFLoLNoS87EralPmcSTTmVzUNptLh/f9bxmL6Qik5HZ9TJucbYNBxg7TClDEwkIS5dQT/1rloyAJ1JMZzAn/VRrRUkKP28my4DFb8GK1d6AAmQzWIiptxvcS2VRFQKOcDMpx094p6Al7TR7VsSyVLSI5FEciw5lPCIHzIpPQuT7Kqa1Ls3lRGUscwJuO4tT9e5Blhl5GBOpibjJurtWsN9oIcupi7RJ2DBkN8/VDoRqQ/qQj6hyFKojgBjIFKXMQaKjWDcWiwOf+Qv1wQe1I7f7FGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOidmfW2cSFehnL1G7SwSlPZKJoK5MptFWfnws1/hQA=;
 b=FRITHkR06/rsXzx9GfDXSEJAwzlGuUTG0YDiCeLy5ZSJnMrbB1zKgoFM5FKxI/apaHJI5bVO4ZX5TbG6kURXX8IGMIap7eS9CttT8QmtD1Yl6QMXQ6/cRQOb/ipFzAhg+fo2AJCyDOGXCDuBaC6BG7XWHQO1svzVIRqxHGWnFzQ=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CH0PR10MB5353.namprd10.prod.outlook.com (2603:10b6:610:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.29; Tue, 19 Sep
 2023 22:15:14 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8979:3e3f:c3e0:8dfa]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8979:3e3f:c3e0:8dfa%4]) with mapi id 15.20.6792.026; Tue, 19 Sep 2023
 22:15:14 +0000
Date:   Tue, 19 Sep 2023 18:15:11 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        oleg@redhat.com, giulio.benetti@benettiengineering.com,
        dave@stgolabs.net, ben.wolsieffer@hefring.com
Subject: Re: [merged mm-hotfixes-stable]
 proc-nommu-fix-empty-proc-pid-maps.patch removed from -mm tree
Message-ID: <20230919221511.jvmorb5nqmjiybjf@revolver>
References: <20230919202216.D1DB3C433C9@smtp.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919202216.D1DB3C433C9@smtp.kernel.org>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT3PR01CA0020.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::15) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CH0PR10MB5353:EE_
X-MS-Office365-Filtering-Correlation-Id: 86a5a93b-e263-4c97-40d0-08dbb95de5dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: irtqxGf54Eh2izhzTK9mjgfjbk+PX+gcpi/RKXDNwl7t8jLWGonF6qWvZbWBBBmMOwRrCv93i3TkUnK2CLs79FG7UAjj+SWgA7U50a19XM6aoeJZTZvLIXrPpAtRlX6IKCapjelaskONPAHncqGqNi5Ri/AfAkbwzmBFSMxKnO0e30HyL1nfwXdiEP3FPdUR5nylhqEmVw1rrf2+7mePI93jrjOfYbfLzcNJRxqmGk9zTDeRb2R58Amlb3VYoUPJhVuwgELSQ8omV5ErgOZ3vSXfr1bRG898X2zR6y+bmUV5fPDvM4IHMqS9TOe7pBMh5wonLqXGJFaZvN/ypHHoMhvxHoAX9bWwHG4+vxyQ+sBoRHXILx/xGNGWnFYEh70AChQzzhje27VTYa0RVCeWx3EiZskM5bh6w3TRRjqjGBR1LbO9ZWqAjMiqSY9zGTyWPnN9MmrXTBm7TCBgX6bqnBHpTIZ0y1tDXkoj1VP0c0GMeuDaU1+EevmnZlKjnwOy7FpkY7IzAcExbSaVzN9xnzwzKQgh5oglT6zudpSbUYw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199024)(186009)(1800799009)(26005)(1076003)(83380400001)(6916009)(66946007)(5660300002)(66476007)(66556008)(8676002)(8936002)(41300700001)(4326008)(2906002)(86362001)(38100700002)(966005)(478600001)(316002)(6486002)(6506007)(9686003)(6512007)(33716001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5jzRTyw0Ho1VMvhoVXEh9O217FbGXOOvqBcHu3kjz8FlgrebPIfndH/7Q6OS?=
 =?us-ascii?Q?dHvJs1YZ/FT2PBccnM26Uf+sr73G5NBSmnhgrF61xWCjAV9y0reV2c0ff1Iu?=
 =?us-ascii?Q?2Y2lxW5ahW/tMT1ktqUk9iB64d6HzeuVpOx9d7x9XH6scbWLM13+2UMO7ZU6?=
 =?us-ascii?Q?mFNqTvU7FiSEGiYZUi37uGWhQEm/3YRWVc/GD3UB7wvPlK9iBFQ9dBCdvq8J?=
 =?us-ascii?Q?5Ujw/4Mhu518gtysjtFz6L93mxppmc0nA5z4mf68etmgCPZd2Bhyv0wg+/WL?=
 =?us-ascii?Q?Xd51Zy1l5Ec8WpxOeYeU4hLeGiUUJNbLohB5FXfZIHINoEOYqfpV6OvQi1sI?=
 =?us-ascii?Q?XgeZ0D3dv7EGidvQIAspkHj3yhIrdwbusdnycyF8cWReUKoIg66gWKgKhnG7?=
 =?us-ascii?Q?B0LQ2PgkFgLsfa/XUwY2CDG7PkyLfPJyaHfodmpWwWobY0s9PZHpGbEmdavZ?=
 =?us-ascii?Q?Ck4MSRTG5YiC1xiXFGJbz5plsD2R3TSIDe8yd4WYYzDv+/1ZG+q42nDYTz0P?=
 =?us-ascii?Q?3HqRtU/dZSUWtkxpFQG60KUNiEvPzjoEQ5vm01dTrYZxhHtJu0zQ/Zd4uu56?=
 =?us-ascii?Q?SB7B9Nl7sjzF9x8eaLV/ryDEwf9ZKxDmjv2zZKbh4rnkL0oSlE3PaRhAQc+o?=
 =?us-ascii?Q?ahLSJJVxTE4Y5KPo8fNNKpfKhqK6Y0yB/BXn1o9lIlKPxhkp09w6cBhYVGry?=
 =?us-ascii?Q?mEL7+KqNCHqetBbdkKcNxF4pDlO/qula7SsEVj2zCdltH39aSbMtxcC9roeB?=
 =?us-ascii?Q?oB2iH+uPWIyO9lh/eJPq4/RYM7DgQ0HNAhYij4f8PCHxA2FnHRcXXT+wssHm?=
 =?us-ascii?Q?SWu0X1LNtcluuC2pbeyENYTWsEsFJyftvHmZ+O4i89hkBDal0dFXWtyIYs2i?=
 =?us-ascii?Q?BZ7VYC6U7vaJppZ8QsDtt2a943gCNA6wWpcGIKVLFQTGmnlt/7rfvYTwxUku?=
 =?us-ascii?Q?VdpDIMtepZEDJEDW1NpJTB9guWuc3nNR4Sn5EpWOZk+YbXJVRTTGI1Ywb2fN?=
 =?us-ascii?Q?GcZgOzLAEmvm2HjUUX1tlCGsNft+ioc+MvuFAqu9jSzw8xp8qdIjJbMQUGXR?=
 =?us-ascii?Q?aNwwp58fpc7bIi8Xs5zQFNK9+F6lf6xvsVSj3WfEg+/yZGAFpej5HqEwdtWn?=
 =?us-ascii?Q?IlC3gqP5ynJEFxOXfpomlWTaXMx8WhyJhXamsJ1zecJbaFHaVJ/BSXZdbvmn?=
 =?us-ascii?Q?PeOp0Bqo2VYEYNv1Yp1TsVqv5OlpVrbOCLahR2UaElaAP7gdMdJWyUQE2Yxc?=
 =?us-ascii?Q?NeZGXYyVbeG2XFir/smM/L3aTFjaFaFKpsfWm/hkjvREZ+p0Ab0vgQayX4gB?=
 =?us-ascii?Q?e913I2vJ+NFPY0cN/8W5zbAsO5OfRwUaICdnaXJMflixcZpWraHs8pHy7Q/W?=
 =?us-ascii?Q?USYShLrqo/GqrMopAPv+03wndjbiIC+WZf+qLbBElzbEX+47QbKxtzlr8xrt?=
 =?us-ascii?Q?ND0EjJpJzPq1rn9cieadXM46OPVP62Kbx+0zvbKiFt+pXD/+xeXdR8b2zBeb?=
 =?us-ascii?Q?lWETTPFP4NkGbDjGFF6+6wv5I26fLLN/7v8eF4txOUsCFvsldxjiB2WCY261?=
 =?us-ascii?Q?HkoTxUFuhvbp4pJ0gnpHlR7N252qNNz4+BdXC7Z8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?FAed7JNl5eCot9wvitSG2EVMqD/F1Vr708m+Z8XVJraoMzBOmk58JBgQGZsB?=
 =?us-ascii?Q?cH0UOhVpnvkwn05TBaSuH2LxILm9tJJhaQyCcw5h5IxnC8G83O4wMxqapxQo?=
 =?us-ascii?Q?X2W/vS/GH4cUGnuzx/lBqH6jTLFEiNZe8z1qT72HxYUw1nGZPUfvDjnbKudR?=
 =?us-ascii?Q?F7aRqwII9sUgSzwVxsagmzDcbwFA5ZquFns05bnaGASPR5BTTcnGthlUnVan?=
 =?us-ascii?Q?eDwsj1crOAzZbRLXlNlg8HgNz2zuwEh10PLFB/x/oXbrlkagxkSFR+whBXYW?=
 =?us-ascii?Q?a3slLlt+OErJosClWmL3DGuxvCy2/LBXeco9jZxLdWrnxI4/qUPEcLflfJOc?=
 =?us-ascii?Q?DGo55/1a7zh6of0IBmchdoS/RKRsnKQIi8AU6ZJEFyNwZjRPZGwvfoZwNSHR?=
 =?us-ascii?Q?lP5IoMkMl4aAIbx4lPpPDkxJwa6GkASSiLBJpVst+k8xFyXDVwlFG9hc3Tfz?=
 =?us-ascii?Q?lhac21BlhX3sn6OHVCWVlX8wUDX4lOXayhFztcBORuRK3haDTXnZAf1e5loZ?=
 =?us-ascii?Q?nc3A10bnwaDGzxjds/WiG2M5SJTMrKSPBMQNvgFUduyK99+IZQPsSf/AblYY?=
 =?us-ascii?Q?p+Uu5ia5nyp/7kHn3i/rE5X7E/FnBKWyHlgRDr6XCcLSr88kA4mQg5tX/5rN?=
 =?us-ascii?Q?BLN2o9rIrk1KNWcr54QK3jAF6+18axg2EZyZpX9Tvi6Bw0rYbX29K20UAHJA?=
 =?us-ascii?Q?J0kypHXZmV4VGaYGGw4K/p5/jalaW5IVEM73nCkB8B1su/sN7VzCl37SqUIL?=
 =?us-ascii?Q?5LEhoRMWuQIV2yEIWjXCXH3AwFd/1k2OW+cS+XUEN3Z3MpaYz6ZUzwNapX02?=
 =?us-ascii?Q?2BrHsH2o58XrcEjVjEDwdYq81YIHBezmrDcoTieY3gr4oXZJUDjuQ3RQucAs?=
 =?us-ascii?Q?5vp+aLDrCJdIS454ft2r32W7fwFDA2f7SwhZoxPkvwehA35QGsCQ0tnH/blI?=
 =?us-ascii?Q?5F7fe21j/JQcFLX56FvErK6sqsfJF8n40RAZhkC2iLT73jjJ0kH6CCX7Ehk9?=
 =?us-ascii?Q?m7vhZVcc+BjPHH8D36ITqQHDoA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a5a93b-e263-4c97-40d0-08dbb95de5dd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2023 22:15:14.3981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDy4jWtumHPYof5vDezlT6A/JazYh8vZiUqcuhbiFEWLyoxEkLnMKEiQ4sP1SJIz5E6EVqG2w5SSYwW2FYjKRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5353
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-19_12,2023-09-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309190190
X-Proofpoint-ORIG-GUID: PioWPSg_Qk2IisuPuXKLO8uPfJgzE5km
X-Proofpoint-GUID: PioWPSg_Qk2IisuPuXKLO8uPfJgzE5km
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


I think this has the wrong fixes tag, as pointed out by willy.

It also does not fix the underlying failure of find_vma() not doing what
is expected in nommu context.


* Andrew Morton <akpm@linux-foundation.org> [230919 16:22]:
> 
> The quilt patch titled
>      Subject: proc: nommu: fix empty /proc/<pid>/maps
> has been removed from the -mm tree.  Its filename was
>      proc-nommu-fix-empty-proc-pid-maps.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Ben Wolsieffer <ben.wolsieffer@hefring.com>
> Subject: proc: nommu: fix empty /proc/<pid>/maps
> Date: Fri, 15 Sep 2023 12:00:56 -0400
> 
> On no-MMU, /proc/<pid>/maps reads as an empty file.  This happens because
> find_vma(mm, 0) always returns NULL (assuming no vma actually contains the
> zero address, which is normally the case).
> 
> To fix this bug and improve the maintainability in the future, this patch
> makes the no-MMU implementation as similar as possible to the MMU
> implementation.
> 
> The only remaining differences are the lack of hold/release_task_mempolicy
> and the extra code to shoehorn the gate vma into the iterator.
> 
> This has been tested on top of 6.5.3 on an STM32F746.
> 
> Link: https://lkml.kernel.org/r/20230915160055.971059-2-ben.wolsieffer@hefring.com
> Fixes: 0c563f148043 ("proc: remove VMA rbtree use from nommu")
> Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/proc/internal.h   |    2 --
>  fs/proc/task_nommu.c |   37 ++++++++++++++++++++++---------------
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 
> --- a/fs/proc/internal.h~proc-nommu-fix-empty-proc-pid-maps
> +++ a/fs/proc/internal.h
> @@ -289,9 +289,7 @@ struct proc_maps_private {
>  	struct inode *inode;
>  	struct task_struct *task;
>  	struct mm_struct *mm;
> -#ifdef CONFIG_MMU
>  	struct vma_iterator iter;
> -#endif
>  #ifdef CONFIG_NUMA
>  	struct mempolicy *task_mempolicy;
>  #endif
> --- a/fs/proc/task_nommu.c~proc-nommu-fix-empty-proc-pid-maps
> +++ a/fs/proc/task_nommu.c
> @@ -175,15 +175,28 @@ static int show_map(struct seq_file *m,
>  	return nommu_vma_show(m, _p);
>  }
>  
> -static void *m_start(struct seq_file *m, loff_t *pos)
> +static struct vm_area_struct *proc_get_vma(struct proc_maps_private *priv,
> +						loff_t *ppos)
> +{
> +	struct vm_area_struct *vma = vma_next(&priv->iter);
> +
> +	if (vma) {
> +		*ppos = vma->vm_start;
> +	} else {
> +		*ppos = -1UL;
> +	}
> +
> +	return vma;
> +}
> +
> +static void *m_start(struct seq_file *m, loff_t *ppos)
>  {
>  	struct proc_maps_private *priv = m->private;
> +	unsigned long last_addr = *ppos;
>  	struct mm_struct *mm;
> -	struct vm_area_struct *vma;
> -	unsigned long addr = *pos;
>  
> -	/* See m_next(). Zero at the start or after lseek. */
> -	if (addr == -1UL)
> +	/* See proc_get_vma(). Zero at the start or after lseek. */
> +	if (last_addr == -1UL)
>  		return NULL;
>  
>  	/* pin the task and mm whilst we play with them */
> @@ -205,12 +218,9 @@ static void *m_start(struct seq_file *m,
>  		return ERR_PTR(-EINTR);
>  	}
>  
> -	/* start the next element from addr */
> -	vma = find_vma(mm, addr);
> -	if (vma)
> -		return vma;
> +	vma_iter_init(&priv->iter, mm, last_addr);
>  
> -	return NULL;
> +	return proc_get_vma(priv, ppos);
>  }
>  
>  static void m_stop(struct seq_file *m, void *v)
> @@ -227,12 +237,9 @@ static void m_stop(struct seq_file *m, v
>  	priv->task = NULL;
>  }
>  
> -static void *m_next(struct seq_file *m, void *_p, loff_t *pos)
> +static void *m_next(struct seq_file *m, void *_p, loff_t *ppos)
>  {
> -	struct vm_area_struct *vma = _p;
> -
> -	*pos = vma->vm_end;
> -	return find_vma(vma->vm_mm, vma->vm_end);
> +	return proc_get_vma(m->private, ppos);
>  }
>  
>  static const struct seq_operations proc_pid_maps_ops = {
> _
> 
> Patches currently in -mm which might be from ben.wolsieffer@hefring.com are
> 
> 
