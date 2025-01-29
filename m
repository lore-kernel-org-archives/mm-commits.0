Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D3E29A2;
	Wed, 29 Jan 2025 20:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738181428; cv=fail; b=kSBgUkDxo+k5S3XXZhLVRSzSHYeKa8pN+NyPPA+n3gJzfseEQjfyWdmJjVxBLi5Og6cZ3LxUFRgkkrikDnJ1wKFWVR/mp7feL2RJ5qAkpvZqFzl4DLMDq07Kmu1SVQAXe2wGRZf/A4jX4LGyVsqLMBAV363kqaLfdAwmpj6ywEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738181428; c=relaxed/simple;
	bh=4E87OuG+tPyNQF4p87Z8EfmlkPoFz2vpiehKZ11A/4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OzLuGd0xZ4bkn5CTZTZ4CsMm+XG1MApv0/bWJJsxFLPoD9lEddU6aplRs9+qU5LDofVqG1LNvsl2/5Qp8z/8tMrG7aaXOIPMBI8+DYA5kjMp9E9m+bpMzMLl2A1rMF9+lfc8EZ3hFoaBsli1jcjhCurtYQSveyq9G8TobJ+CqwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W9VBmDzp; arc=fail smtp.client-ip=40.107.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W9VBmDzp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ApO0EFdfabAA9iXD/uyPPFVjiEFXBRw0P5+I5X/Qk+/oCM65DWtCJz/lrKLN3wHqdTcrjuOAbXP8Fm5Gaq5cOoCIbhDNA8noNK8PTfsLx2QdHyALEC3mUAti5ChyqvLyYV3O0FCbRHm8RLIW+bBCmJCUqMGBm0nsu8f4r5V8zW7C8GknIHG3zHea7StPt+fwUx4JBdV9ztNMBPngcc+0pfdgPRoTjYq07WTiScV8utHCYQCuVe8PhSHjj+cgWI/renqhbNHAM7vVuJSkbh39BFlfCgkyTgmlkGsd8CDZvjZsHxkX7wO5jKkDFvjf+ySIZ3/xp7DKeGE7nwGtLkSy0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLIUDpD16dws/EJH3vijMhOgitrp9yW5uxB7EtZpKas=;
 b=Iik5bmUGotIuFomxhmv5P3QJ0XzII62yvJH+qHhyz0pNqXQJ7/0XtI7eVeliyr0JHKEKmb3EyGUQc5eUbIodPoVAsP1gs3kSY8wWZvw78KvWGM6HenU7zTR1MVdRmQqr4EzzceOCqwUDADf+8BPnVBrncs0PgNRZOOWyxNNVK7jEJU9brT6z18iXY7ZqfT6C2RJcO44OTFH0j21+iHpBoWsZbFaRSpoFqty6ODu6xFcsu4Q5ZBsggRlmVdZpfOxE2/QSJl7wcF9PsyYiLez2nLP+Ub9W5zoXbkAAJ5ERxLC3cizh7Y2rK7T509CtsBd37tM266r3s0cKpxaT/jfU4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLIUDpD16dws/EJH3vijMhOgitrp9yW5uxB7EtZpKas=;
 b=W9VBmDzpyJcL/89hKtDGDZowUNQbq4lOFQMUYb9qiRWWo5t1mvw0d5i2K8Kdp3BBPmoRTHjAyr3i5wwSZVBpTkmZm3OgR+jqk3fxZd1KkCYaJ0SYbsE21AZDgsdFPGJHNIvCfg5ZAxb1LWe4U6/LMxclMA5KDhVm6X8sY1OM2t8i+baOreUASLuegHqPpHqNCPQPbvlLO/XsPlwAbWTRlTII8srcxXCIUo2Tj3ytMCjgu7FegwBFnYk9o+cFBddmie+Skwg8+PG2xBXuReYnLYZjFY1AcFdXDAtgGNcF9sjcl6VZdv+SJJkVgGVFC8QdaGjVwhfyCzts8jLJbws/wQ==
Received: from BN0PR08CA0013.namprd08.prod.outlook.com (2603:10b6:408:142::21)
 by DS0PR12MB9060.namprd12.prod.outlook.com (2603:10b6:8:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.17; Wed, 29 Jan
 2025 20:10:22 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:142:cafe::e) by BN0PR08CA0013.outlook.office365.com
 (2603:10b6:408:142::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.20 via Frontend Transport; Wed,
 29 Jan 2025 20:10:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Wed, 29 Jan 2025 20:10:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 29 Jan
 2025 12:10:07 -0800
Received: from [10.110.48.28] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 29 Jan
 2025 12:10:07 -0800
Message-ID: <9312cc52-71d0-405f-b317-3fdccbd998e5@nvidia.com>
Date: Wed, 29 Jan 2025 12:10:06 -0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: Uros Bizjak <ubizjak@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<mm-commits@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
 <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
 <CANiq72=fj0MHiwy5i=FWZxfP_=XsFpjojywF91N6ygdumtQbwQ@mail.gmail.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <CANiq72=fj0MHiwy5i=FWZxfP_=XsFpjojywF91N6ygdumtQbwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|DS0PR12MB9060:EE_
X-MS-Office365-Filtering-Correlation-Id: c999c83e-87e8-4eca-6c07-08dd40a0f5ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGV3RzZ0NWZOOVlqalJDVjZRQnFRWHZHa25CcVFORGVDWU9yQlRzeHZnR1M1?=
 =?utf-8?B?ZUFQejA1QllNdStvQy81L3FPYTh1cFNzYnR3K0UyWlAyejJVKzVRYVBhT2dq?=
 =?utf-8?B?Z2cxK3pkazN5ZTdWZTZCWmgvUTJncFRPcWZoY1hKWXFLSDNVZmVKcmVxU2Nl?=
 =?utf-8?B?WUU4RWZZMWh5dEFyQThnN3VPWVJrRW1iV1d4TGNQWlRHN25nMVp5ekxHZlJP?=
 =?utf-8?B?OWtYWTZ3b0kvQU9EcEdmOTB0VVp3V21aL1NoTTd6cXhteVJPOXVkd2RvZldN?=
 =?utf-8?B?MmZQOEhwN2xyVFYyd3dyQTlhdkFjbnZsOFJnRWdXeWdXdFBEQ3Z3UHNFT1E2?=
 =?utf-8?B?OGJSaXFuaUJGdWtpd1ZnMzBRUzVWZFdERGlUazFjRUNNVGE3NHNBVEU3bXNh?=
 =?utf-8?B?L1c3WXdFaTdIdUN4K2l2N0JhOUp5UWVEMXk3MWdxdVBXQVpaZmNRQy8xMDRP?=
 =?utf-8?B?NFBTK2Z1dVR3QytzcnhxdUlqN3lrank1aHZiVGs5YThVYWQ0NWpKUXJxWXd1?=
 =?utf-8?B?VklSaVUySjJSZWtKVUxJcFJUNmVROXJuUW1DdXVydmdLa1d2TFVZTm92YmZS?=
 =?utf-8?B?Vkp3SDkwdnpyc0l1Zk1OUU1DdWxIK2U3UFk0TUgyS2JHYW1xdmFOclcyY3E5?=
 =?utf-8?B?Y01xZHJQVTdNL3hPU21EeEZYdXVxYlcvNWRFVTg1QWkxaXpwcCtYN0Uydzd3?=
 =?utf-8?B?L0xpcDdEZEpZSHl6bVNYbHJKOHMxRW40eFFXQUdHVzVGcGdNbWIwWW5RTFRO?=
 =?utf-8?B?YUsvc0dEaXI4b3JHSFJZVXZUVTNsVDVIaWVReDN2TW9XV3hpS1M0OUUxbldq?=
 =?utf-8?B?QkhMa2NhL0NjUUxxTW5mL3ViMU1zUVhxWE1na1pMYWp5WEtBNGtuZGVISkxU?=
 =?utf-8?B?U0NvZ0VPOUZXUXRUR3VrUkM2ZEdQYVlqNUVybHU5VjFJekJDalVkRXFSKytr?=
 =?utf-8?B?UlJLMWpLL0VET2JOY0RDTU5GQks2TnhCTzl2ZDh3b3pKU0g3ZjZHOVRINGdZ?=
 =?utf-8?B?OGhPblVoMmErSDI4cXpDa29yVXFVUFlMZlhKeFdFK1FlT0hxbExIellCbjVu?=
 =?utf-8?B?RWUyMFllQ1lpTlhLZGVLT0lnZE9mS2FvZXhQRGRpcDhvWGFWbG1PNjdsZ0I4?=
 =?utf-8?B?TllIejc1TnlobkVYSTdSUDNUcUYyUUdsUlJiOENhS1BBWDVHTE94YUNqb1FC?=
 =?utf-8?B?czhRMXY2V1JOMHEwbzFwcUcyWUE3dXdtVnd5L1R2R0FJYU5WMWk5MXRJSVhH?=
 =?utf-8?B?WFQrY2NBaFFwSUlMOXNpbG8yVW9ENnhTZzlMWjR1NytXaTNLRmVjeUlUY1BJ?=
 =?utf-8?B?UU05V1JYTzNQNEdZdXFTc0k2VlE1cVhOUEdFT2ZNRm95YWxSZWR4MFErZ0sv?=
 =?utf-8?B?TGlrZHRCQ0pndXdqV1hvV2FWMWlLODVrMnlkR0JnZ3RlSjdvN1Z0Yk40TW9M?=
 =?utf-8?B?L3hHbmZvUk4weFVnejdySUdxOWIyaHMySzJ4ZVdFcitEdTZ4TjRHVm1vZTdU?=
 =?utf-8?B?SmdHb0ZFUm5nYnoxN08ySFJUYnZIOUJmNm9LdzQ4RDVaOUR6dExKbTN2L2w1?=
 =?utf-8?B?SVFvczdKWlFUaDcxcHBHYWhKRjFjLzdyT1hEQ0VzZFp0NmEramdxTldvS0x1?=
 =?utf-8?B?REpqYWZUK1djekhMdTU3VUtjdDR3aTIyMW5vOFhkYnl4VFFCL1RTUXdPaGhP?=
 =?utf-8?B?MmM2dHlEaGRoTE5OZXZrbEhpWXR1WitiTldUbFBSNk9PTHZYanMxUmFLWUNu?=
 =?utf-8?B?R3B0NWFpR04wRFR6UUJFNC9sVjlhcHUzODRXbUlrMGJ6QjBFOTBmaGU5di9S?=
 =?utf-8?B?dlIwd1FOWnpzcVlxd294aGUyTWJBZVpuYjFjdktkejFJMk5GaTNtVXNuWUJr?=
 =?utf-8?B?RERQcGhlUDlac1ZVSld1aWV5Y2lvYjdtNkE4Wmh5djNlWnNDbjBGd2V1b1Ev?=
 =?utf-8?B?VkQxOFowaCtTdm1QS2JGdnJUc0lERUF6bWFNSGVSaUI1OWtWTnBFWXhtZTdN?=
 =?utf-8?Q?oVkTS5G+pk5rLnG9Pivxj3i/7JIDKc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2025 20:10:21.5084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c999c83e-87e8-4eca-6c07-08dd40a0f5ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9060

On 1/26/25 12:58 PM, Miguel Ojeda wrote:
> On Sun, Jan 26, 2025 at 7:30 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> That seems to be a reasonable assumption. I guess some crazy setup
>> *could* install a bindgen that uses a different llvm version than
>> rustc itself, but that sounds pretty damn broken.
> 
> Tangential to the issue, but a note on this: we have a few warnings in
> that `rust_is_available.sh` script for things that "do not look
> great", such as bindgen's libclang != Clang when `CC` is Clang, and we
> could have a warning for the case you mention, i.e. bindgen's libclang
> != rustc's LLVM.
> 
> However, currently some kernel developers use toolchains from upstream
> Rust (e.g. from `rustup`) instead of their distributions, so that

Yes, because the distros themselves actually recommended it (Arch Linux,
anyway).

I took a reasonably careful look at the Rust setup for the basics to
build the kernel, for Arch Linux, a couple times, and for 2024 at least,
the answer clearly seemed to be:

     Use the distro's rustup package
         Use rustup to get rustc

     Use the distro's bindgen packaged

Maybe that is All Wrong for 2025+. But this stuff is changing as Rust
and Rust-for-Linux start to settle down, and I'm a little concerned
about warnings unless they warn about something that *really*
matters.

> could be annoying for them (since their bindgen may be picking
> libclang from their distribution).

Trust me, the Rust installation is already sufficiently annoying.
But maybe I'm just being paranoid, and the new warnings will direct
me to a better setup.

I'll take a look at this if you CC me, though, and see how Arch
behaves.

> 
> But eventually when things stabilize more it could make sense, if most
> developers stop using those, as a by-default warning.
> 
> Cheers,
> Miguel
> 

thanks,
-- 
John Hubbard

