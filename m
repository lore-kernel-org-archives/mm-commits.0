Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B4C22FE0D
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 13:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757339194; cv=fail; b=l4JBYKJKe67/S2tsfzV84VttJBvvF1SVsQbFg5wC84sUShL8m8PlZUufCFe+KZhicGd9bwJqTcJTRx/Vc++nyP7wWv/FIcM6y7CA5qkokRhkm5PEWj2U0fvY/iIOclAep3/3Cts0g5TzF2Kzysbqj6KtSd9q4TGw//K92pzlAnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757339194; c=relaxed/simple;
	bh=yCyjhT/hBEMLypc7B9XtZSmchJp8XYUUQKX8cWFKpCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NXF6iGrOFV5bbrFX9WYMn7IMYDofTBmqfkE6XsSg2mknt22yS34TJsVCqv+ZxtI2qtSQWC9mNtvxSQdAuD+ATKNiStEbReQrYQk3czBQOSqhL/x8gwHZqYJUByNr4bU2csfzBqM7YSbNA2YF33xxu5F94erntUnDgUbKz0xPhqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ONTFxmY6; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ONTFxmY6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m9cu5T2AdzasYPl/fOKZa73/xSt3NWY1wxj0FK9A81wq1xr/Ca3Yguh/pSs6Vsz8dVncn9ny1su40/4Ze7LMQlUFlNrKR6tYF2UdWewVrGWpAXJRJUXByQmyxBE12gkQOCBSocLfmIdZ8/OhAICvyLbLWHn77dDPDNgmDlRZeEeVOZikFTAW0eIogNUtMXcpVB78IkrNXX3vlXvVrzOrRz0ks4jvIsepoAnKZTEowZs6cHQF+bmSOkMwLYMoHifZnfR96m2HblbkrvqPywxb8ft1gOIPhf8VN8t0VRYBZ1fCNeyUbPJDcct+SzGJ/A8L3Mss4U4QOJebNGakwUu6WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFxBecr8ob/67oophaAqAIoKW4WBrR6B6dACoxNWyEQ=;
 b=q6S4mUdvrCtrIGoJeDXgYk8O1JBORCZAbDTZKAzxeka7M3gJjJU18uVLkJQ1BOHNOE1Ni54XYsn2Lhe0RXe2jD22Dx9Ynlo3fyjqdITBTNGSACs60nqtfsEA/HoGhd1NmVdw2crK4Ua2wL0JiX60lztkYFppmjERNzDCmbx2CKT5ehPZkyrjFynghnvAqJzEqYqjJMmUXJI/Q8hC604JYX1yUVcM2+XRsrGsAByrK6r4Ur17MTOqDvOIf/S0YDiOLjV76ChLteF0GSn/uemm22PKcJ3lBKVCX1s5V3nXa7WB80Pmkh2mCvuZSzIIylZD0J8yG0PThQOj5wuUF5l/qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFxBecr8ob/67oophaAqAIoKW4WBrR6B6dACoxNWyEQ=;
 b=ONTFxmY6BHZWaHYt8kaZiW7tK+oCXk/PB0+UD5HR4bFnxpqh6CquxS/54CrYS/kZkD4zMz7cTUAzSex7v7Mpq0Z+c1eqTtCtWekSQvJyZ7NebFtS7EZhr89NEn8w/J22AI8o7GiZiDmpQ7pj0OqFjiIjgd3oNFAK2cynUgAxXuYexHy/Z3p3CBIEoT6DfLplDGmP9F1DY1MDw0RMOmG5ZyPTKdHm6ScBggLslPXXwXF7LizW9WoupwND06Y69+yJLY9vk4YlEaznsOMc5dDsSa+D0a7YbJej/vUDzOSVVJ90oxoitT18QpfcLrWrjmRx2S92AHMACRsaRHVqgqijuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB6064.namprd12.prod.outlook.com (2603:10b6:8:af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 13:46:21 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Mon, 8 Sep 2025
 13:46:21 +0000
Date: Mon, 8 Sep 2025 10:46:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Francois Dugast <francois.dugast@intel.com>
Cc: airlied@gmail.com, akpm@linux-foundation.org, apopple@nvidia.com,
	balbirs@nvidia.com, christian.koenig@amd.com, leonro@nvidia.com,
	matthew.brost@intel.com, mm-commits@vger.kernel.org,
	mpenttil@redhat.com, thomas.hellstrom@linux.intel.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: populate PFNs from PMD swap entry
Message-ID: <20250908134619.GH616306@nvidia.com>
References: <aLmTWhL36_ciqajA@fdugast-desk>
 <20250908091052.612303-1-francois.dugast@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250908091052.612303-1-francois.dugast@intel.com>
X-ClientProxiedBy: YT1PR01CA0120.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::29) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB6064:EE_
X-MS-Office365-Filtering-Correlation-Id: 382c4b40-5f2e-4dc2-8cce-08ddeede17f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0dHbVpFcVk5aWdsY1R1ZlgyRnZ2Tmh4cnNWcXdFOFBvWFQ4WTA2c1VKVWFa?=
 =?utf-8?B?YkI5K3V1SElTblBjMnBYUERFWEtoSVJYbGZpYW5yMTUrUGsrTW9MZENJU3Nx?=
 =?utf-8?B?eERWTm1FRkZaQ0JYd3lrSzdFei94SDNDYklDNFpyamxtWjBnWkxhd3VnUG9B?=
 =?utf-8?B?UGdFVXppRzJ0UmE1K0k2a3UvM3I1bml1T0pldG1ubUlPZzExNDRzVjNxRjR1?=
 =?utf-8?B?Y1JiOWZwdUl1VjBtRkczcW5POHhFemVNaVg4czJUQ0s4NHZNUWpCZXVpVWpS?=
 =?utf-8?B?YTJTOStTRUMzWFRMM3Y2SkZNRWozUHVaa0FUazMxaitqZlF4UWRPbi9WNmZl?=
 =?utf-8?B?VGFNUURXQzZSR3BhOU5IWlVWNC8vd2F4LzkxMGw3elZ5V1gyY0d2TFcwVzBS?=
 =?utf-8?B?RzU1RmpEK1N6b0dBSlc0NDR6VlBNclFESE9ETlk4YWc2YkM0VFg3WnpOQnFN?=
 =?utf-8?B?RGF6R3EvOWE2K1dkYzZDSHlvWE9mVDA5TU5vaVNER2JOMXFzQWoxbXR1TE5C?=
 =?utf-8?B?K09vTW1IQ0hub25kZkN6aDkxOVZjZDNGY0dWZUU3NklJNTl3WWxVMk1ZWTFW?=
 =?utf-8?B?U0liWUcwaVJxcWNFY1FZQzZSZ3RqaWpaSWRtLzFkTnhXdDlLTm53ZXNKblNN?=
 =?utf-8?B?YW9BTVA4R0xFMW40OVNGSThpRGFGQ0VnbGlvbGhmRXRUcGI2RzVFM1ErZVgy?=
 =?utf-8?B?dVlUc0s4MW1DenlibWZlT1lrbkVvU29vZGxJeXhtbkFwaWtkdjVKeHdCeGEw?=
 =?utf-8?B?eSs5RVBZT1BML2k3SVRXTTF1ODlUWTM5THR2VHNqQXBlbzhYZmFhc1d0VUkz?=
 =?utf-8?B?UStaWTdQSzBJR3VoNkcwdm1TSW1FS0MxV1dkT2g0dzRXTmZCbjBPNkZab2E4?=
 =?utf-8?B?aVYyL1duZS93NmxtWjg5MjBxTURMUW5Od0RTMmtSdUp5Qng3UVFiTTZUdnYx?=
 =?utf-8?B?TjBuUndoV0lrMERRN2NHdEhSQkRNQWF4N1hKVEgxektZbHlHck5aOHNVN1Ft?=
 =?utf-8?B?bVpjTzlSbEpBdWI5blhReDNJZEp3SzRGWE5pdXRKZGsyRXQ4eXpvV2dQUG9S?=
 =?utf-8?B?Tm40MmJKSk93ZGE4YnBpTUpHWVJIeFEyeW1rUjNMU1NvK1lrTHRyM1BpS201?=
 =?utf-8?B?R210M2wreWRyM0c3b2NyN1RNYlJQZDNtU3I5REgrbnMveU5FbVpRMUNBOVBZ?=
 =?utf-8?B?QmhWVEdVWHprMzVncklMWER4MXdwbHR6VDlLb3hIaHVDanVTeEFRTzRsWWpp?=
 =?utf-8?B?ZmdLRFE5U2tjVnRGanJPQmJ5Um9JMG9JM3lEenhoM2VkRDlhRUQwZDh6ckVC?=
 =?utf-8?B?UWoyM3lHY1dhM0UvUlM2dlFmQ04rcENTWk5OVEVYSTE3bU5ydWdJYUI0TGdB?=
 =?utf-8?B?NVhxckxIaWZKYkNPK0p5d2tKeHBJaWRUWHFLdm83ZSs2Zldyblh4UDBxVXFa?=
 =?utf-8?B?dnk3VHVoRzRseGFFangwMTUwU1ptMU8zTDFMb3daYnhKTExQTzNLNWdVWXRK?=
 =?utf-8?B?VVNMRUl1TEIrSUI1YzVnajkwTnJ5aDQ5N0FhYVpNNGVzMkNiTlNZSFFpcmdp?=
 =?utf-8?B?L0RVZCt0SUR0NzNhcnVUck1leTBBRmZtRTB3NmFXOUxvQTdPUEhVZTRtNWVT?=
 =?utf-8?B?K3BGYk5OYVBtQkxhY2JkM2lVSm5mQk04VkR0dGZUWXI0akJwVGJOSGcwUEtk?=
 =?utf-8?B?bE5aUkdqMFExcHFEL3o1allVK0dwSlhEc1FFUDN5eUViOXBzWkVMbkxYUm5T?=
 =?utf-8?B?M3JWbFlQaWdZM2hLcWVZWjY1Q0FMM2FaKzQxQU5uditDMk9XamswcE9uNGti?=
 =?utf-8?B?NmE3VGtzc1IyUVV5cEluL2cyZnBFNFNvaFdZWjVkekphUFFQaktjZUZNY1JT?=
 =?utf-8?B?NjMzTjdCczVWNmJWbXlHYm5uaERkQWdsNkZoNmxUN2xlcjVPWWhBWmtzMnJE?=
 =?utf-8?Q?+KA+DUtggGI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVg0WFJRNmdiRmExbFo4R3gzODJjUFlkUlpQck9MNDJGRVZKZXg4VzJueFRC?=
 =?utf-8?B?bjd4SlV2WG9mZ0hZVkNENHpZSWRBVW9qaFQyL3l5c0owYlYvaUJ2RFJXZjVG?=
 =?utf-8?B?bTZJbm05bW1qL3dZQm1DVlBVM2NPODU0ZlVkQmJHWEJuNWlMQ1BRcWx0YWQ0?=
 =?utf-8?B?eE9WdjVsSjlmN0Z2dlozWEpJWnBpMzN3cDRXdS9sY01hVkRqSjRmYnFMRk9j?=
 =?utf-8?B?U1J5b2dCWmpMRmpTKzRGK09WcGdwamlsbW1TN09VVEJTNWlVUUFPVU5SZlZ0?=
 =?utf-8?B?akhkb2VFd2w1YTM5eTlNUTdJNTl4M3NuU0c0VSt3RnVSTEhjK2p4R3M3eDJo?=
 =?utf-8?B?Q0tVOWRtREovWVFzajdaMGZJcHc2d29DNHpqMldybTNmUUpuS3ZmSXkwMGc4?=
 =?utf-8?B?MlBZSE9VR0VuL1VnR3JKVnBVbXFPZ0t6amFiZEg0cjdZUzhjUWl1OGlzKzdj?=
 =?utf-8?B?dGdqLy9aL0dRUXBNOHVGdWV3WjZQTWlXZ3Y5RUFPNFltNEVYbkp1aklmeTNW?=
 =?utf-8?B?YkZ2Uzc0aHk1WW9mNi8vSSs0bysweDNReVFjQnlObWdZUkdmR1hZSW1rckpz?=
 =?utf-8?B?aExXZmxoajV0b041TCsrbDFvSHVmUVVydHdnaE4zUWVwb2tQaEVsU2RzTTc0?=
 =?utf-8?B?UlFMRk9aZk5SMVhUNGdJanExK2ptQ3lDcWd2cjZWNmpIWFJPWDlvZ3ArNVox?=
 =?utf-8?B?cVJwYkFhZ1I1OWpMaGdCcjZSM0RMUUk3c3h5Wi9CU1ovdWlsbGRJYyt0ZHZt?=
 =?utf-8?B?NTNmaGZJOE1vczFMMUdJU2JGTXJ5TUdqclNjbm9vaGRNbldPV29GYjZCOC9K?=
 =?utf-8?B?UmsxTjJJT3hYbm1zUEhjKzVPbGVFbDNtRnJKV1JQVThFUDNPTkk1VmdtWTU4?=
 =?utf-8?B?YjBxQWpSSjhsWGN3N1E1NHFLVGFxTUNLbnRmOUR1U0g5b0FwYUJ0NTNLZFN4?=
 =?utf-8?B?ZjVsOVVPdGYxenhXZy9HczZCYjVwWm1lZXlyQ05OSXZtUytRQXNXQkZYcXhD?=
 =?utf-8?B?empBN3dnREVobEJuVEErcjhvVjk3R1BFVkx0ak1naE82NVpVT3BLaVNQaEcx?=
 =?utf-8?B?YzNXeElKdUovdGhyZmNzQzFsdks3dENaWWg0TDJ4WCtWSlVVME9NY21rak95?=
 =?utf-8?B?NGdQaVVmUEdIRG5SeTRXRFlXb0JtUEk0ZTlXcXlPZDhrMFBnVUxDVmZDRDVw?=
 =?utf-8?B?QjVnOUxlVzgwd0hCUE1tUVZpOXdIMHI5S3FmNnZkMjhNNDR5bkdsbHREMjk5?=
 =?utf-8?B?WGttQ2FUeFhWNTh5cnl1TkFCV00ySm1RRnRQRk9WTFRkRzE1ZVl4VDl3NkQ2?=
 =?utf-8?B?dEJ2TExZdnNBMDZWbVc3azlKQi9DS3VTc2tMN0Frcld3UDd6NUNhdE9YbnFM?=
 =?utf-8?B?WVVWaEZWVkJJMDFVQTRwZzRRZDBmMnJTVUk0N3lOZlNtQ1NVOTNjd3JrMlBN?=
 =?utf-8?B?SmVSMm1sNEFtTHhqbDBkNU9oYzQ5dkVSNkVkZ2JjTXhUQStoYWVtVGZoRi82?=
 =?utf-8?B?UkZNako2cFBLaEl0WmlRZ3NPaFhoc3FSVnhWdUg0MkJSYVcvYStpb3ZmcExC?=
 =?utf-8?B?VWF4Z0k4eC9PZUxHNDU5V3R6d01wY3FNRERqQVJTWkJ1Tm9wdllrRjJvMGQ5?=
 =?utf-8?B?UXB0QWMvUEJYSWZwVVViOHJ4bXpxQitNVzB5K2VzMG05RjdBWXYzVEE4a1ph?=
 =?utf-8?B?RXUwcyt6WGI1QjBwOFlqU01nM0VjWWhiaVZMZjRKTWIyTW85V0xOVFJSZkhN?=
 =?utf-8?B?T1FwQTBTQXJzTlVmZFlNL1BmeFJyY3JINGxtZTFmbFJKbmFkbHMra0dsZkNu?=
 =?utf-8?B?akFtdDRUNmNkNzhJY1lUci9QK3lPcHNiSmpMYi9BWlU0REl5VVBwOGcrT2dC?=
 =?utf-8?B?OWRRakpUOFpMdDZKWmt0cHBlZkp4QXNiVVNmSmQvRW5FYW92VUpidmQ0RGdi?=
 =?utf-8?B?TUlycy94SW5xYkVFWG90QWFHZk9yZVVvRTExRWNjWmRwWjVUL0V4a1p2MnFV?=
 =?utf-8?B?bXJrekZXalJtOG5qTWV5U1BSSzA4WVFzWEF1Vmd5bDE3Wk1ybngrSE1td1or?=
 =?utf-8?B?dkgyY011K1lMdENmM2IxdzR0eHQyWVdPQ2VaS2lhTUZaYTR4VGRDcEpSQnEy?=
 =?utf-8?Q?uvcE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382c4b40-5f2e-4dc2-8cce-08ddeede17f1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 13:46:21.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXH/dHXzTFqmX0iXgMlkJaXhINSmV/gVpkKI1g4+4T04jgvqdXhpzWZacVpbXxf/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6064

On Mon, Sep 08, 2025 at 11:10:52AM +0200, Francois Dugast wrote:
> Once support for THP migration of zone device pages is enabled, device
> private swap entries will be found during the walk not only for PTEs but
> also for PMDs.
> 
> Therefore, it is necessary to extend to PMDs the special handling which is
> already in place for PTEs when device private pages are owned by the
> caller: instead of faulting or skipping the range, the correct behavior is
> to use the swap entry to populate HMM PFNs.
> 
> This change is a prerequisite to make use of device-private THP in drivers
> using drivers/gpu/drm/drm_pagemap, such as xe.
> 
> Even though subsequent PFNs can be inferred when handling large order
> PFNs, the PFN list is still fully populated because this is currently
> expected by HMM users. In case this changes in the future, that is all HMM
> users support a sparsely populated PFN list, the for() loop can be made to
> skip remaining PFNs for the current order. A quick test shows the loop
> takes about 10 ns, roughly 20 times faster than without this optimization.
> 
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> ---
>  mm/hmm.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 65 insertions(+), 5 deletions(-)

Please put version numbers on your patches and include a change log.

Jason
