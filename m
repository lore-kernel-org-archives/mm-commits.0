Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2116.outbound.protection.outlook.com [40.107.117.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB7520B02
	for <mm-commits@vger.kernel.org>; Thu,  4 Jan 2024 10:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="nI9vtlsl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoiqyrCxmHZVczU+GeKENi/QWOd1mB8tW3EQH06oyjIZnksBvLBJ+AnJIYKLVru4Fd6jK0/Ccbzt5I5GnX0Eh2NmmlB3afVS3/Ei31J8D3D8dyuTvd9xxuR6js4TIKGXfISGKC9t1rCW9kHzzeRCFNjO8f8n2SWRVDlTcs9acIuSHHh7m4j+pGcsJKdMqGD4PJIz2piGE6WzY6XpVrakaedw54PXhY/GnEidM6XCF+5y/KiJQrKN/eZjEhOFl82FwrKtuuuXrZ5FuvtBlJsB9TLdef9uWoFtqH9rkfANBzaEyHn/JCmJN9TTOhA3cwDkbUQVQ9YjmMrwPH2/eHPkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aQDjlWhWdpqHlsXM3gl/Zf183I9Y9KyBUkLUpxSWPA=;
 b=dalMmotbbAfUlBPGYzfk9088J9wamnfpQuZypWszPojliBhzkhZDMftsFr/b+WL+cTmuE/RIGSHYCVBQWptBLw4Fh5PIlZ8Mk8jAlsUEcuOVfmBYHq5ZMsVCRjpXqPuO5AL6GFvG6LbLpmciEZLq4CTx1nU/jsvJF5ruVw0Z+gKuFDMeG8oPTIQz5hbWUIwADKgeU9b9vpXo+RZZP0gZS5lOR3wt2yktyJGt2KSrIACUcFaq7tAMrNqciDAPeFIay8cCTXEkXGyVyginutzDqPCeKnKJZtI+TG5WyVSVX4ijvpDaeGnTsyZz3V9k4Gyd/MbNPrTqseIiJ7CfA+HpeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aQDjlWhWdpqHlsXM3gl/Zf183I9Y9KyBUkLUpxSWPA=;
 b=nI9vtlsl3wuFxbdXQLlCC9e5EP/GkGSpvRyB9UjIPKm7xMi0cuL6hBMr8o8FfvOxj1TMbKbVKdSLq4Qp0m3gFfDJdISpyGGmBudWyD/YmbnOZ09dPvYYihkGdhc5drwYP+2J6bssaM9izuQnVZNthwj2KtuYRGvGImLzBDFev2ykCONGtPAVqKezVoMTjZJAqRVXyWBAAsV1zOGhfSwJxtZqPOU7U2GVKr2eV9icK7hfHS8pb33yI2bLgXnr6H9YolN46+mJYU32UZKm14V4wtfBfkcHugR5WWzFwscw5jdqZPeSLu9m48NrhH8ZSCazO4L5DXplkYIAzd41JH4dLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4045.apcprd06.prod.outlook.com (2603:1096:400:21::8)
 by TY0PR06MB5428.apcprd06.prod.outlook.com (2603:1096:400:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Thu, 4 Jan
 2024 10:02:20 +0000
Received: from TYZPR06MB4045.apcprd06.prod.outlook.com
 ([fe80::9925:32d7:c818:3c5]) by TYZPR06MB4045.apcprd06.prod.outlook.com
 ([fe80::9925:32d7:c818:3c5%7]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 10:02:20 +0000
From: Bixuan Cui <cuibixuan@vivo.com>
To: akpm@linux-foundation.org,
	mm-commits@vger.kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com
Cc: opensource.kernel@vivo.com,
	cuibixuan@vivo.com
Subject: [PATCH -next v5 2/2] mm: vmscan: add new event to trace shrink lru
Date: Thu,  4 Jan 2024 02:01:45 -0800
Message-Id: <20240104100145.3855-3-cuibixuan@vivo.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240104100145.3855-1-cuibixuan@vivo.com>
References: <20240104100145.3855-1-cuibixuan@vivo.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0091.apcprd02.prod.outlook.com
 (2603:1096:4:90::31) To TYZPR06MB4045.apcprd06.prod.outlook.com
 (2603:1096:400:21::8)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB4045:EE_|TY0PR06MB5428:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bdd9a6e-e0dd-493f-8fe1-08dc0d0c3dbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U7kLjafaIJHk49fHDOV3v/wZfxB9nmcWxeZsZfkpNeiNuCRp8kfLwoxJayZTJG8R1Gfl1sf1/iZpKD5ZBrYoI3CBhS94rY1sfYGKw3TKcO+3skS93LeP/YX7aL7JI+uYf+9/N9aEz1QPMGSPmr2CSt7bq6KeqVnvYIM0DyAo5huh7X4LqnbvmwV7IIAKnpguPEA+HBBOPb1RaYAn5jIwCbrlDzSIByMedJmqWwYSFJE5465YnRaL8mmUVnzqQvnrtpjBHvGRjQqfzOmkBv+woy2xgC3BvBi4G3erZGZvqbECYyGXRCKPeco2A02yjjXceHyDRmbQVd96+iv2rk4AnAuO+BlbuHfLwhGC+IH2KSDyMrTtuSrsjdVX1ZbWztxyhZSNZYPT8XbLebl+rFKRmXLlM01V98hsbPnylb75YOrxy7qC5wEgbziQeQSC7lP4nJuAjnU7WkrwCaP/6/Honh+ULwGkv/9OYuYmfN0yIEYWl7iskAcfztpirzrbMhej56gKT+DQKd/68TApF+F05JZhtCyfvAFOi1RMT65TmEXNgKYxgxF3g6SCGVVRlXzyN9ur0TaPHoS+a8pOsQ5v18P2CBMjOM40B8o58+dcZASTquNNaDr+LDQnHuNcvjKt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4045.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(366004)(136003)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(5660300002)(52116002)(6512007)(2906002)(6506007)(4326008)(66476007)(66556008)(66946007)(6486002)(6666004)(8936002)(478600001)(316002)(41300700001)(38100700002)(8676002)(86362001)(36756003)(40140700001)(83380400001)(38350700005)(107886003)(2616005)(1076003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rVrLFW7EtvT4ecYtYRAuVpy6I3XJ80i5NDghaeqcwRc/N3IKanecsy9XiECb?=
 =?us-ascii?Q?shJxrE1S9RrUbLJkAkUZp4FjZa+tzgTNxXWG0bQBdinp6uX9fdXlLZUyuv/5?=
 =?us-ascii?Q?7N8vxOp+dZ1TtDsBsb/cbvYJ3uWq3eIK26mjvIJAvBc4yYazfS0kvHB7lgXK?=
 =?us-ascii?Q?jw/gqX0ppIjFKjh3iok5PvTvJLnkvx0mvuY1PEOqzuA6gI4sgGcJ0kDJFdrR?=
 =?us-ascii?Q?izV6nZ7bjacZht7oQLPF5f/zPYZsNcM8AS2W398mRzLs0Y7lhvvCycWVqoVn?=
 =?us-ascii?Q?k7PumrtjU5GgZmEa5BYgGePc0IMf9cmLpHN1o5dPMQ6FDn9Bl1/gmmPq7q7a?=
 =?us-ascii?Q?35UFJd/6ryrpLEjbEZFuHtiqWD330fkVkQR22sAhrVNN0vXW/zZ5Vz9hRek7?=
 =?us-ascii?Q?3h8yOnvCuvgvHwP3fD12aX10WSEW1gQPa85dHCiJwswoeJ1S1gkjVCIhaCe1?=
 =?us-ascii?Q?Qa0Oa5NkrqZqt6qFo/mvjaUdcWc5NHSIDP9obk0JDZU/+FE5I65sn75Ux2hn?=
 =?us-ascii?Q?dUH5UWI0i07u16qpI8nHLvg9Ccp/fXN4Bdng2I0F0yl5BCLeuI4X6RcaNvdM?=
 =?us-ascii?Q?EK62MiJXxnyhmWsElSLFj/p5XOdGqGVl7MEm99BpcAm60cFlzzPLPZWU/EOI?=
 =?us-ascii?Q?8X/Jcs/ATz5ZYFlncaKHTzG3QAk2GNmr1/PkWFmsXnlt7lpEv9a7O+TlpMR4?=
 =?us-ascii?Q?Ri77wBnMNXJ2Rybxn3Ohydw5FWg6Tva92PPZ8K9P9IeaiXoOW1aICqJ71RCF?=
 =?us-ascii?Q?WtzkBMpp6A3bSViPGASAYmKAKEweiy0z1j8oSVeIEe6ofZDDw8feJyl353Kw?=
 =?us-ascii?Q?AktHR3jGWaTATNyGcgdyGOx+89mcQOE81K5eDkfuFwG+1jYi5ZyDRI7T0Ak6?=
 =?us-ascii?Q?9KYAgBzZ4JLRw/zGzh6YI+rg+eC8Lf2jS2hhAcQgHWe4K1KQkmHinmi/hGPm?=
 =?us-ascii?Q?NS14VfViFg5DXcL5CNPeRKhbCsZGo596wM5YW5zHVM/ignztv3ef6qdOE6TQ?=
 =?us-ascii?Q?hMcLoTlpUsp84RJLVlk03UeT5a00fDMlalJK7ObkgCMhzmHJU/odc8ywJ9e9?=
 =?us-ascii?Q?zzQvCPiNcQgcO7OhY7++4W0lkFzVShnxTdC6EkiLby2sHosFVEdTf+eyYOJJ?=
 =?us-ascii?Q?MaQv/fHOGYlb7GznfDhAxI7lLulInUsTCS/2YX2qS+pdFBTe8Girw3jTXKtJ?=
 =?us-ascii?Q?0rZlskmjcTErYvFWQNUiYVIoyYXRsEXxMdgXQ+vh2iY3/QFQEgxRGMODTNNZ?=
 =?us-ascii?Q?MbnITnEVvzH7c67ROjw5h3xPElEgjCfROx6VSNokR4gOMuPDzoX19IlveSei?=
 =?us-ascii?Q?sArF9DWNmw2yLD0IOI/OWlWDiSwlMpoF3WzuI7tSHIdojbBUuwW8QDB5gqvj?=
 =?us-ascii?Q?wt0kxGBNaZhAqKE7BpnqYmq/hINUl7w1oQZqLLr/pyzun9AWhU9Gh7UfjHv1?=
 =?us-ascii?Q?VBh3ccVKausjaH1JpM164PUe2atIE9rodJIqrYk8YESdTb7g/+I1iAY1Upy4?=
 =?us-ascii?Q?/8sq/yEaa/Wj9C0wKqQ83cENIWEd/rKBAgfSkFRdoAVTZJBnW//fDjScFFWB?=
 =?us-ascii?Q?IgJLlkxoEWfuqD8URVIe48c+BEGLXw7BkkHd+sIl?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bdd9a6e-e0dd-493f-8fe1-08dc0d0c3dbb
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4045.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 10:02:20.7633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sztK1TsiZofJ3/t41e7x6EatVh+jEmLEmiS1CNJxgdW7XQaaqEYdRJuCVFpM54afMLCiIMK5bJo9hmNxMEfukQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5428

From: cuibixuan <cuibixuan@vivo.com>

Page reclaim is an important part of memory reclaim, including:
  * shrink_active_list(), moves folios from the active LRU to the inactive LRU
  * shrink_inactive_list(), shrink lru from inactive LRU list

Add the new events to calculate the execution time to better evaluate 
the entire memory recycling ratio.

Example of output:
         kswapd0-103     [007] .....  1098.353020: mm_vmscan_lru_shrink_active_start: nid=0
         kswapd0-103     [007] .....  1098.353040: mm_vmscan_lru_shrink_active_end: nid=0 nr_taken=32 nr_active=0 nr_deactivated=32 nr_referenced=0 priority=6 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
         kswapd0-103     [007] .....  1098.353040: mm_vmscan_lru_shrink_inactive_start: nid=0
         kswapd0-103     [007] .....  1098.353094: mm_vmscan_lru_shrink_inactive_end: nid=0 nr_scanned=32 nr_reclaimed=0 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=32 nr_unmap_fail=0 priority=6 flags=RECLAIM_WB_ANON|RECLAIM_WB_ASYNC
         kswapd0-103     [007] .....  1098.353094: mm_vmscan_lru_shrink_inactive_start: nid=0
         kswapd0-103     [007] .....  1098.353162: mm_vmscan_lru_shrink_inactive_end: nid=0 nr_scanned=32 nr_reclaimed=21 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=11 nr_unmap_fail=0 priority=6 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

Signed-off-by: Bixuan Cui <cuibixuan@vivo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
---
Changes:
v5: * Use 'DECLARE_EVENT_CLASS(mm_vmscan_lru_shrink_start_template' to
replace 'RACE_EVENT(mm_vmscan_lru_shrink_inactive/active_start'
    * Add the explanation for adding new shrink lru events into 'mm: vmscan: add new event to trace shrink lru'
v4: * Add Reviewed-by and Changlog to every patch.
v3: * Swap the positions of 'nid' and 'freeable' to prevent the hole in the trace event.
v2: * Modify trace_mm_vmscan_lru_shrink_inactive() in evict_folios() at the same time to fix build error (Andrew pointed out).

 include/trace/events/vmscan.h | 31 +++++++++++++++++++++++++++++--
 mm/vmscan.c                   | 11 ++++++++---
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index b99cd28c9815..4793d952c248 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -395,7 +395,34 @@ TRACE_EVENT(mm_vmscan_write_folio,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
-TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
+DECLARE_EVENT_CLASS(mm_vmscan_lru_shrink_start_template,
+
+	TP_PROTO(int nid),
+
+	TP_ARGS(nid),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+	),
+
+	TP_printk("nid=%d", __entry->nid)
+);
+
+DEFINE_EVENT(mm_vmscan_lru_shrink_start_template, mm_vmscan_lru_shrink_inactive_start,
+	TP_PROTO(int nid),
+	TP_ARGS(nid)
+);
+
+DEFINE_EVENT(mm_vmscan_lru_shrink_start_template, mm_vmscan_lru_shrink_active_start,
+	TP_PROTO(int nid),
+	TP_ARGS(nid)
+);
+
+TRACE_EVENT(mm_vmscan_lru_shrink_inactive_end,
 
 	TP_PROTO(int nid,
 		unsigned long nr_scanned, unsigned long nr_reclaimed,
@@ -446,7 +473,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
-TRACE_EVENT(mm_vmscan_lru_shrink_active,
+TRACE_EVENT(mm_vmscan_lru_shrink_active_end,
 
 	TP_PROTO(int nid, unsigned long nr_taken,
 		unsigned long nr_active, unsigned long nr_deactivated,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4e3b835c6b4a..a44d9624d60f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1906,6 +1906,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	bool stalled = false;
 
+	trace_mm_vmscan_lru_shrink_inactive_start(pgdat->node_id);
+
 	while (unlikely(too_many_isolated(pgdat, file, sc))) {
 		if (stalled)
 			return 0;
@@ -1990,7 +1992,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	if (file)
 		sc->nr.file_taken += nr_taken;
 
-	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
+	trace_mm_vmscan_lru_shrink_inactive_end(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
 	return nr_reclaimed;
 }
@@ -2028,6 +2030,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	int file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
+	trace_mm_vmscan_lru_shrink_active_start(pgdat->node_id);
+
 	lru_add_drain();
 
 	spin_lock_irq(&lruvec->lru_lock);
@@ -2107,7 +2111,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		lru_note_cost(lruvec, file, 0, nr_rotated);
 	mem_cgroup_uncharge_list(&l_active);
 	free_unref_page_list(&l_active);
-	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
+	trace_mm_vmscan_lru_shrink_active_end(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
 
@@ -4524,9 +4528,10 @@ static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swap
 	if (list_empty(&list))
 		return scanned;
 retry:
+	trace_mm_vmscan_lru_shrink_inactive_start(pgdat->node_id);
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false);
 	sc->nr_reclaimed += reclaimed;
-	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
+	trace_mm_vmscan_lru_shrink_inactive_end(pgdat->node_id,
 			scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
-- 
2.17.1

