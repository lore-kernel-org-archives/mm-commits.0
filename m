Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0CA1FCC46;
	Tue, 29 Oct 2024 03:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730173579; cv=fail; b=WJqjB0eZFCt7MDyPHO7fhLKdnNqiVcU8LWRCQnApvqvAjAsquydAM17DMdTXnZHDaErHXEOi5cL2r7pn8UxMMYMk5em9Vag/21P1s1TYM/YQqLZXV6w/WpUQAu7CuU3w8X5TEK96b8iEgswIYg8Kc0nE+9mbTC6bVPO849DCSmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730173579; c=relaxed/simple;
	bh=mGTYFnEyrQFUs7UVTgpxQE063ifhFPQz1jemMfzC4Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mcXvxLGHmHXE1A/hwgYuDKhr1OmfrIbxlvfKP2br3aqsTcbym8t2SR9sfpeIl5YH2tnwsepS4lva4FvCSduKUggQN7DgW3vaoolTca6G0RrYu5BZJXdmtKulwBBaAt8gQPVgAIc5WLyjeUb9ESV2e8nha+E6D09+zLvV9KPG9wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qL8FWl2n; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qL8FWl2n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ig2TPjUNGp+rhihiBJL4ND2LFfCvUMw/TO/PdMN7fLGSFKLesGCin3hWuqoVuw66HePi9qxou3Pxh74lXP01MThkmOr/7b4z2Hn8TevTbVxJkifKcSF686Aj686PjnlxCrzEDYw/+jFLpbP9vx6+kysd9Bi7kVpu3uVGX2EGVuZBUEVfEzWIPI7G1zRViMHIaOVyDUY/Q22xIKdvXYHIOr10QcfzJm9xIWdU153eWMI6M8GF0tyX9Cf+nj2h6pVyGrrSgY1fkbN//ndlEjUMR8OkFwU52K1ouMs0vE+Ru5I34MieBUf7eLosi7Rxv0tIWbhgqbbkphSpU3TAqct2GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJ9rjKVNY5XYMf1Pstk8I2g5FcE3IstEdylOklMRlSA=;
 b=e/WVcFpbvX937op01jChM6yrie3BzMx1J1JMJ3YmaSzqOuQCb32up/3TIPEy+lRgaLrH0pJfM48Hj+0MUWO06SnNTiJYE+Aq2Nc10zO28xFnzRLxlDaZgKSwdKq+HXsv+PE8/fxz7iLT4LI5mlnVL7zWPGa252LE7LU0cCU/1Yd1CMVT+SSMeQpqQmJtZaZ2JrFrJvW2eYvxrG4DoasN/urUJ+CcU8CAnsUyTdMAHP40CRWu8b08ZUxMlmlZWYjp498AxBguzSpFVvSPt/rAknuQpEjeH6MT/ysWeOkkEgW2cV/R+m+Acin3Vjid/ozRkdDikmz/FjsdmbLN529aYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJ9rjKVNY5XYMf1Pstk8I2g5FcE3IstEdylOklMRlSA=;
 b=qL8FWl2nzUBZLDiavx/f5k4FYT3GVBHsQp+29X6Fq44TbdnJ0t8/V5CKgPKpWmTPOdepWfgvncqtKCI1ayEfHHasgluojBDeaBbK5ELI7J2XEqqaEQyVsX1vfPfI/gIJeI3L6ufVAK5TkzfB5DZSzXnr17x+cxl6iG+c/3F9X++QXonU25RY+xc9SwykXdKWZqqpUibZj2YW4qekp0ChtmNG2huKcMfUnlzC+HN2pRYfB25RLPNgYF66WDo6zIgkSfGGiHwoYUpYlzrM6Mu9dREmu2zKmqnBKFqn3lBfhoaS3hZgGdRbtMD0kk+mQ+Tc+fVnmWtb6YW5uS1UnDtRyQ==
Received: from SN4PR0501CA0056.namprd05.prod.outlook.com
 (2603:10b6:803:41::33) by SN7PR12MB6815.namprd12.prod.outlook.com
 (2603:10b6:806:265::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Tue, 29 Oct
 2024 03:46:13 +0000
Received: from SA2PEPF00003F64.namprd04.prod.outlook.com
 (2603:10b6:803:41:cafe::7d) by SN4PR0501CA0056.outlook.office365.com
 (2603:10b6:803:41::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.13 via Frontend
 Transport; Tue, 29 Oct 2024 03:46:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00003F64.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.16 via Frontend Transport; Tue, 29 Oct 2024 03:46:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 28 Oct
 2024 20:45:57 -0700
Received: from [10.110.48.28] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 28 Oct
 2024 20:45:56 -0700
Message-ID: <6434b6fc-d3c7-4f1c-baa4-25215a185eec@nvidia.com>
Date: Mon, 28 Oct 2024 20:45:56 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] hotfixes for 6.12-rc6
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: <mm-commits@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20241028203743.3fe4d95463aaafe23a239b51@linux-foundation.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20241028203743.3fe4d95463aaafe23a239b51@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F64:EE_|SN7PR12MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: fe755ec6-093b-40e1-1b06-08dcf7cc3c3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3VIdGhiRUZ4Vi91SExuYXBWdXd5YTFyQUlURWF6MEtrL0pkTkgxNVB1WlhO?=
 =?utf-8?B?RUFjMXliTjhhNDFKdmZIckRqSEtSbHpHbTRONkYzUFJvbkU2VnJpRCttUURG?=
 =?utf-8?B?YW5CWVo2emRhbXVFVUZmQytWOTgranhTNnhkdCtaSENpWitUQTE5K3d0UUxv?=
 =?utf-8?B?Z1JSdDkzTnpOR2lYKzJVYXg5S2c4OVpHbnpidWxxTCtVbFZmdXFHQjVFVjlQ?=
 =?utf-8?B?dklpb2hESDNkK3pnbkNpRGFKQUJRZENudlFyVTNhcTRrc3hkcTRHRDJCMm1Z?=
 =?utf-8?B?Tm13c1oybnlhYjdjdmhkWDZiYlJOMit3TTdtY2lnUFg4Z3JwNTRVSi9jcTJx?=
 =?utf-8?B?SU1VSjRFeW1KMXd2TUJlVitEK2REVVYrVDA5OGFsV2FOc1ZQdHBYMGUxOWMy?=
 =?utf-8?B?WTNjWXhFZzhTYklwZU5McFRzYnhid2p4eEw1NnBOZklFR3VmV29MU2MxemJ1?=
 =?utf-8?B?QWlqTXYwNkVDUjlKQ0xNSERxd1YyNEJNTGVMN2xHWno0SHNrNE1BaHE3MHFx?=
 =?utf-8?B?SDI2SkFFUkNLeURacTFXajRBUXlQc2FFSjhKbHRnZURMU0xnVjNUb1RuVnlI?=
 =?utf-8?B?Q2pVU3VhMXNhR1p3RTRCcGlzNW1HVWgwQi94VklUVklMWVVJSGxSQ2lmZEFK?=
 =?utf-8?B?RVIxRTJhdzZ6TTRRVDQvejM3MjJXZlRRN3Uyc0ZsalRPUzZKbXhXbHRNSlc5?=
 =?utf-8?B?Q1pkY28yRVNYTTQrNHgxTWhEOXJUT2FzUHpSN2svUzZYNnIyS3lKVkxFUjh5?=
 =?utf-8?B?SjZsLy9lMThXZjBPbURUV3hKUVhOTDNPQ3g3VkpUTTJzZkpRbnpxeFJpY1lJ?=
 =?utf-8?B?YnRRcld3MWVtRnF1NFBwVUs2WW9uYk54ZEV6bno2cC95cUN1R0NwTlBBVWJR?=
 =?utf-8?B?Z1owT3NaWENuZ0NJeTlhQXZhTVhFd1hScFB3UE1SNjFaTkwwZG9yZm51dVhx?=
 =?utf-8?B?SWhnUXpRUlFQSmh5VVRpNDIwWU11VU4zSEZpOG81eXpzWlBrdEdYLzVBUngv?=
 =?utf-8?B?YzkwRzZJL2dsNFVvMTFIWFIwNU1DZ3dhdTQzbFY4NFhqREEzSW5yMy9MT1Nu?=
 =?utf-8?B?cEZPL1cwUUduc0tHWXA2aXdRMGZWcUlaNGRwb1JMZk1ENUo2TXlpc2dLL2RL?=
 =?utf-8?B?aTNrc3l3WjdYY1ZRazdyeTVmYkFrVU5WQW1iU1J3Z21YWldMeXBLcVJOUm1z?=
 =?utf-8?B?Qmp4ZUV6UjdOdUJXTUZLQjZhdU9RT1VoMHBVUm91OFhJQlhxWWtzUjhKYnJo?=
 =?utf-8?B?ZGQ3YWZ6YUxYYSthdXpGYXhrOVlHeVBta2dUalFLMGJIS2R3Y1RVVE12YnhB?=
 =?utf-8?B?U2dXUldXdFZZeXZNVGMxdVFxalcvUXh5SldrYTU4RGhuTldJTGo5VEhkVm1p?=
 =?utf-8?B?OWhobFM4Zk5DTTV6Zy9yZ2JMV1o1WEZDaHI4N240ekRTYnkwT3dtZjNPQldV?=
 =?utf-8?B?TjA2TjBFOEtRbTJiTmNrbGREc2dvbG9Pc0g0Q2hKSzZCOUtQQWsrczFZaDlQ?=
 =?utf-8?B?NnZmNVM2dGNndlYxM3lLcERyV2kxTE1Mc3FEL1N3RzdlQ0tXKzVqdHpyVkZG?=
 =?utf-8?B?RmFZUXRueENqdUthMHZDazBTQ3IxTzgzUVAwaHBpRkJjWWU4V3l4dmJGbjgx?=
 =?utf-8?B?NmpyN053Lzd6TlhXS1d5clo2WDMzdEZ6L1VaMit1RUhVZ21QeUhhTWtnbGZ2?=
 =?utf-8?B?YWl4SDYvODBXY1pOenNxblJkMUplVTl6dnRIRnBHMnd1Q2NpM3BqaDVZWGEv?=
 =?utf-8?B?UUg5ZW9pdllaakxweWJlVnpkelNiaWcvMEdnN2tRaXBzaU9YTHNSNnBFNEpu?=
 =?utf-8?B?dEdVbllFd3c4eHpZUTErZi9hcnZEQVNHWlhDZWhRbkdkNFVGVm1kclV6Y2Fu?=
 =?utf-8?B?TU9vdEpucGI5a0ZtMktsM2FCZnMxQ2s2ODdweDJRbkxqYmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 03:46:13.4297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe755ec6-093b-40e1-1b06-08dcf7cc3c3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6815

On 10/28/24 8:37 PM, Andrew Morton wrote:
> 
> Linus, please merge this batch of hotfixes, thanks.
> 
...
> John Hubbard (2):
>        mm/gup: stop leaking pinned pages in low memory conditions
>        mm/gup: memfd: stop leaking pinned pages in low memory conditions
> 

That's the v2 series, but after some more review, we settled on a single-patch solution,
which is v3.

v2: https://lore.kernel.org/linux-mm/fc42d9bf-3460-4d85-a09d-39b5634363d4@nvidia.com/T/

v3: https://lore.kernel.org/all/20241018223411.310331-1-jhubbard@nvidia.com/


thanks,
-- 
John Hubbard

