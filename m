Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B17188010
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 23:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729293041; cv=fail; b=JhxBgTNDBwY9ntQTJHCXOfo/bjhIurFJ3rjGYRa9U2cGUmxoVwoQPcW4MC8DXOda3fNdav/VcIrm2SGfWraGsm00yy0sOdV2kMfzLhvJblBYyma7fp1ANRalxjgnDMjsnyiTACj3J7rEeISfx6n735ly5ktlndbI3uNY9Ih2Nyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729293041; c=relaxed/simple;
	bh=QnGqsoak1XgEIanqZuhanrI3nTHC4e0VeLgle7/Dwe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZnPocMkSnQhE0hoMWA9+zlTIQhF7RwId9vg6srhzv3qaJPyLu6DzoTwPMT5IiTDDLsV5LX66U4IynE5lEMZFt1Y2upsYxAqTEfMzU3cer2/z/Ubgs/SUXDV829evJBdm2R1NNGTfOaPx7hi3uPB0E8kVreMrm65hf6RW5mfbz7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WBzHktEt; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WBzHktEt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mUU4FhBmXuZcm+C6OKReCPZWyGOrpkOc3/GYEyXuQZrT3U6vCdLFeT3lPMWVH2wpNhxoKacr+UdZ9IEuW1tWyCUqlhJy82elj5tYG2KiuQFEG4cAQCNG0qVnnZOdTqvQeyZdF/VedYGkukUx8RnhDIxn5zT9joaHz8b07nQQLqyHnLmpFKTgkin3khJjgZSmqmi0j7yv2K4COFuC7YDhjw5yN31eCTAJkboqU4yQGLkymM2XguklBHImyfcuDQ40gfnwCHIu5ghdHXk2UH8CjFl2pNCLDW2RzsYBiYZhMqBdG1RcNTVhVmz3Y4IwWMDHC2bQi314QNmdZ1gmQEgJVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=foOC4GguiSiRWlxA63Qq8N1NNnjv06PlJkOdv9fGWAk=;
 b=vUQo5tv9SZL9Lxl+s2j4TDmh0pLB/YVpf7z7/dSQ66oxQ6hk7iWBYTIeL1OGot9p6BoaJ+aXo6+2vE6CvAEDhRUXgGStQAIkXVbio2UteD6udYdGtD/qAWaTz0vlRqUpcjG4AfMGSwGg+IsucsrsIv4hlJPzvfC5lQnMVR2HGMHPB0Ggn5EmcTJf68xaF6blS8bQrXOQWKRpmoskZ77hDisJi4A3PaxQ+3z4AsmlUpg87XBMwQs7Rki3qc7E7Ia0w8gbkOSEDqJIu2dk/JMifn7F13s2iZ1sK0E7kv/ZcbAi9JTDZNk+LdPM0ZMrnCUd4GIhnLXf5EyzMAd0i43Zrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foOC4GguiSiRWlxA63Qq8N1NNnjv06PlJkOdv9fGWAk=;
 b=WBzHktEtlWRX7F2C5RJI5XCmPEScMtdVs73EbEkmV3bt6SDnA7gzvsW7g7PryJhteZH0K0h/r2q47i25BrX7iaODg6PvKI/ixz8bmQScA0105EizLe0L7rw90yZHUbQxRlhcb3dqwC/Sh81ROUaxrZRaqk6f31lSBoc/pAQAMabW8vsulUGyP2NNjOBZDv3iPLL76XcGsBuWYT0smOMKrHNPhOB2QYG0tuNWj6QfbZfrX48Snz6+5AmQLxapX8LkGPPtV6sgArI5D2zzvICaalaBudq45YnPjqfIq6JIM3/uRb1mnoxP6AcLwzNHgSH3lKLorgVV7brhq2D8m+xuBA==
Received: from BYAPR03CA0004.namprd03.prod.outlook.com (2603:10b6:a02:a8::17)
 by MN0PR12MB5834.namprd12.prod.outlook.com (2603:10b6:208:379::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Fri, 18 Oct
 2024 23:10:34 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::3b) by BYAPR03CA0004.outlook.office365.com
 (2603:10b6:a02:a8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.21 via Frontend
 Transport; Fri, 18 Oct 2024 23:10:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Fri, 18 Oct 2024 23:10:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 18 Oct
 2024 16:10:17 -0700
Received: from [10.110.48.28] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 18 Oct
 2024 16:10:16 -0700
Message-ID: <68a61b17-d59f-43f9-bf67-1824677b2e59@nvidia.com>
Date: Fri, 18 Oct 2024 16:10:16 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
CC: <mm-commits@vger.kernel.org>, <willy@infradead.org>,
	<vivek.kasireddy@intel.com>, <syoshida@redhat.com>, <peterx@redhat.com>,
	<pasha.tatashin@soleen.com>, <osalvador@suse.de>, <minchan@kernel.org>,
	<mike.kravetz@oracle.com>, <kraxel@redhat.com>, <junxiao.chang@intel.com>,
	<jgg@nvidia.com>, <hughd@google.com>, <hch@lst.de>, <hch@infradead.org>,
	<dongwon.kim@intel.com>, <david@redhat.com>, <daniel.vetter@ffwll.ch>,
	<arnd@arndb.de>, <apopple@nvidia.com>, <airlied@redhat.com>
References: <20241018224747.DBC0BC4CEC3@smtp.kernel.org>
 <2d622109-11e5-4c5d-8f13-40e695dd2127@nvidia.com>
 <20241018160243.009bd38d3ab96bb05a751096@linux-foundation.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20241018160243.009bd38d3ab96bb05a751096@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|MN0PR12MB5834:EE_
X-MS-Office365-Filtering-Correlation-Id: e3208847-21c8-41d1-0448-08dcefca115e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z2VRVkgwdEJ5S0t5OE04NjQ3dTdsMFNmNEt3aVl4VFEzWFhUOE9nckpsMjVL?=
 =?utf-8?B?bk5oQ2FuQURnVnNHTTkzR1YzSUErNVdyUkRuTXRQNXgzZFdqRmFNRit0cFVn?=
 =?utf-8?B?RGJ6Rnc0Skc5a29nY2szNnFPTHZqempnQTcwOERQcGt3dE9ONVQzbE9vUkR1?=
 =?utf-8?B?YmYzVWFydUJpbzFlM0x2eTUraEtjOWVBMkU5bFRFZzhVcjF2WEFtN3grdG04?=
 =?utf-8?B?ZmtQQWtIY3BQc0dnQkZWZFNVcDNYUm5QL3UwSjlWbEwrN21YQUhRZzBMWmlp?=
 =?utf-8?B?cHJReUlJK1JnNHRaLy9vNjdkMFZnZk1GYU5ESVJ1UENiK1BxWE5ma3lxbG9w?=
 =?utf-8?B?dGZ4VGRGOURaOE8zMWd4REcvdkt3YVpYcUs4UUxTMndjUDdtL2hieVVYRVhr?=
 =?utf-8?B?bnJlalhZL2ljb3ZFaElZQ3NkTXJFUjdHTWhNTTFhcFdua0J6UXdtbGlKOTl2?=
 =?utf-8?B?eVVLQXhCNDBWcmsvUk00TWR3TUwzUlJGZnV4WlRlSkd4dmx4NityTnhLbDVs?=
 =?utf-8?B?UEZMTEdTQnJoSlhjNTVvSU5rbmhvTUNOSkpiTGMvZnhaT0pzN1VlNWRlN283?=
 =?utf-8?B?SXhCV1g3dWIxRk1WK25QUlFqSjNRRTVYTjU4cHdyanFucXFzQVBxWkJsTUd3?=
 =?utf-8?B?SVQ2V1ZXOVR2Z3pvS1IzRlVtMlh0YnlJOGl1cnpRZHZYYjJzWnBvQUowaHNG?=
 =?utf-8?B?YjVZeUo3V1dJWkVqeDJ4bFd5RnFqNzlHZ3VIaGZ4NHBYTjVVVmRLQnBINTdB?=
 =?utf-8?B?K0JrYkdud1VBVzZMTnI4VDkzZk5UVk1oSEM4QlJQY0d3bzUydCtPR0NWSHd4?=
 =?utf-8?B?bTB2RmwxY0VUL3AreEdLNzRTbC9vN0hXWmQ3Yi83T3VuVUlISTFHVWZUWkxL?=
 =?utf-8?B?UUtCeGlkTnF5MFB5UzhOeWtweGN1WE5WdVJPMDQrSG04VENhL2xEelBjaCtx?=
 =?utf-8?B?UExRUGllWU1tbkUwRi9rUGI4c2pISHFKV3Y0ays0NjZJMHpiRmthVTlFck9B?=
 =?utf-8?B?VzhaMkNjUlR0bFlsSmVwazRNUUdFOWp5NnJpL1VXLzl1d3pycExFQkZ5SFo3?=
 =?utf-8?B?SllJYWZMQS9hSDNrc3E2Y1prV050cVpaeVkrTVhzVTNsRlk4R2o4ekR6dWpj?=
 =?utf-8?B?UlcyNm4wUktsRUVEM3YwTW0rZU8yNVJjaFYrNEtJMzVmbnFFVG42UmpsazNS?=
 =?utf-8?B?b1hncG5Vd2FQcmJZRHhDMjRXdWg0N0JHZTVTek9TU0tSblNLemhOR2pTOXVY?=
 =?utf-8?B?bnRiMHNqODk5Vm5DWEJYZVVJaGNlbzlMWTFYRHlETE85eFBPUGhtMWlBS0ZV?=
 =?utf-8?B?bTBOUEIzN0YvZ0NjNkJQS1dQY0E4WnhqcWVNOEYvVzFMbTIvRzVKT2hoaGJW?=
 =?utf-8?B?Z0tyNVFkOXgwckgvKy8zTSt0ZFJaK294bG9TMExMaE1sU2Z6MGdYTzJZSDY0?=
 =?utf-8?B?enNWSk1seUUxT1VSUk42WnJ0QmtSZ3ptUUpHWXRJeEw4ak5tTGs5QTZFa0hk?=
 =?utf-8?B?NkJURTFDbkJlRTQwSk84SzdIc3h2allMeGxrQjBkOTlDMlBoQlJWQnBuNHBT?=
 =?utf-8?B?UTkvVVBTcVVYeXA2STljUXZGby9PR0dnb0x2U1BkUUdONGdiMHF1aGZJcWNn?=
 =?utf-8?B?c1hqclZGSkhTV3dnWVcrc3pwQkxTeFhyU0tUdkNEWS9mVlRpa092ZnRaRzJN?=
 =?utf-8?B?bGNBQjN2bHFNWVRQcG5GK3lCMFdmVUFYSzRPNDhGcU0vWE5OMUR4YVpNN0ZS?=
 =?utf-8?B?dkhYcEFFL0QrT1FCTEh6d1lUYzJudER3aEF6UHJ0WFp2UmkzUFgxWU9yampq?=
 =?utf-8?B?TXhUWHZmOFBldFhZSUdDTXJ6Znk5ekI0Qm5WR2Zmd1NESkhjdmxnQzJoVDFr?=
 =?utf-8?B?T21PVXFsT2ZIdk0xUDdxamRGRzFWL0J2VkFPZmN0TitrQnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 23:10:33.2324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3208847-21c8-41d1-0448-08dcefca115e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5834

On 10/18/24 4:02 PM, Andrew Morton wrote:
> On Fri, 18 Oct 2024 15:58:22 -0700 John Hubbard <jhubbard@nvidia.com> wrote:
> 
>> The above is the mini-cover letter, rather than the v3 commit description,
>> is that normal for this phase of the patch flow?
> 
> Often.  I pasted the revised changelog into the to-be-squashed-into patch's.

aha, thanks for explaining (again, I suspect)! :)

thanks,
-- 
John Hubbard

